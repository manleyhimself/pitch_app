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

FactoryGirl.define do
  factory :image do
    user_id 1
img_src "MyString"
position 1
main_image? false
flagged? false
  end

end
