# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  first_name   :string
#  last_name    :string
#  full_name    :string
#  gender       :string
#  password     :string
#  university   :string
#  job_title    :string
#  company_name :string
#  blurb        :string
#  birthday     :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class User < ActiveRecord::Base

  has_many :likes
  has_many :likees, through: :likes #users self has liked
  has_many :inverse_likes, class_name: "Like", foreign_key: "likee_id" 
  has_many :inverse_likees, through: :inverse_likes, source: :user #users who have liked self

  
end
