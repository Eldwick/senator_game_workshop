class Senator < ActiveRecord::Base
  def self.random
    all.shuffle.first
  end
end
