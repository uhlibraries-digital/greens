namespace :greens do

  desc "Migrate noid state files into the database"
  task :migrate => :environment do

    if File.exists?("#{Rails.root}/config/app.yml")
      config = YAML.load_file("#{Rails.root}/config/app.yml")[Rails.env]
      root = config["noid_state_file"]
    else
      ARGV.each { |a| task a.to_sym do ; end }
      root = ARGV[1]
    end

    if root.blank?
      puts "Please include the noid state file"
      next
    end

    files = Dir[root + "_*"]
    if files.count == 0
      puts "Can't find any noid state files"
      next
    end

    files.each do |file|
      fp = File.open(file, 'rb', 0644)
      state = Marshal.load(fp.read)
      fp.close

      prefix = /(.*)\.[rszedk]+/.match(state[:template])[1]
      if MinterState.exists?(:prefix => prefix)
        puts "Noid state with prefix '#{prefix}' already exists, doing nothing"
      else
        puts "Adding noid state with prefix '#{prefix}'"
        MinterState.create({
          :prefix => prefix.to_s,
          :template => state[:template],
          :state => Marshal.dump(state)
        })
      end
    end

  end

  desc "Insert noid state file into the database"
  task :insert => :environment do
    file = ARGV[1]
    if file.blank?
      if STDIN.tty?
        puts "Please include a noid file"
        next
      end
      tmp = Tempfile.new('tmp_noid-', Rails.root.join('tmp'))
      tmp.write(STDIN.read)
      tmp.close
      file = tmp.path
    else
      if !File.exist? file
        puts "File can't be found"
        next
      end
    end

    fp = File.open(file, 'rb', 0644)
    state = Marshal.load(fp.read)
    fp.close

    prefix = /(.*)\.[rszedk]+/.match(state[:template])[1]
    if MinterState.exists?(:prefix => prefix)
      puts "Noid state with prefix '#{prefix}' already exists, doing nothing"
    else
      puts "Adding noid state with prefix '#{prefix}'"
      MinterState.create({
        :prefix => prefix.to_s,
        :template => state[:template],
        :state => Marshal.dump(state)
      })
    end
  end

  desc "Clear all minting locks"
  task :clear_locks => :environment do
    Lock.delete_all
  end

end
