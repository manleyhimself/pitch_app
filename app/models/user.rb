class User < ActiveRecord::Base

  has_many :likes, class_name: "Like"
  has_many :likees, through: :likes 
  has_many :inverse_likes, class_name: "Like", foreign_key: "likee_id"
  has_many :inverse_likees, through: :inverse_likes, source: :user
  
end
