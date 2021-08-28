##
# Creating a mutex using database
#
# Modified from: https://github.com/mkraft/with_locking
#
module Locking
  def self.locked?(name)
    Lock.exists?(:name => name)
  end

  def self.run(name = '', &block)
    raise "No block given" unless block_given?
    return false if locked?(name)

    begin
      Lock.create({ :name => name })
    rescue ActiveRecord::RecordNotUnique
      return false
    end

    begin
      block.call
    ensure
      Lock.where(name: name).delete_all
    end

    true
  end

  def self.run!(name = '', &block)
    raise "locked process still running" unless self.run(options, &block)
  end
end