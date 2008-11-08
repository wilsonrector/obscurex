class Forum < ActiveRecord::Base
  has_many :posts
  has_many :topics
end
