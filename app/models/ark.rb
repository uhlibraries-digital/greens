class Ark < ActiveRecord::Base
  validates_uniqueness_of :identifier

end
