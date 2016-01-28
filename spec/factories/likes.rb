# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  likee_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match      :boolean          default("f")
#  match_time :datetime
#
# Indexes
#
#  index_likes_on_likee_id  (likee_id)
#  index_likes_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :like do
    user_id 1
likee_id 1
  end

end
