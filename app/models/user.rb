class User < ActiveRecord::Base

  has_many :likes
  has_many :likees, through: :likes 
  has_many :inverse_likes, class_name: "Like", foreign_key: "likee_id"
  has_many :inverse_likees, through: :inverse_likes, source: :user
  
end
