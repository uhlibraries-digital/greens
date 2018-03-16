class MinterState < ActiveRecord::Base
  validates_uniqueness_of :prefix
end
