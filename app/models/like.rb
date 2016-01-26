class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :likee, class_name: "User"
  
end
