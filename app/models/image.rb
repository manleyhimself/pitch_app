# == Schema Information
#
# Table name: images
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  img_src     :string
#  position    :integer
#  main_image? :boolean
#  flagged?    :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_images_on_user_id  (user_id)
#

class Image < ActiveRecord::Base

  belongs_to :user

end
