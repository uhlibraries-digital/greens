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
end
