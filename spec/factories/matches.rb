# == Schema Information
#
# Table name: matches
#
#  id          :integer          not null, primary key
#  user_1_id   :integer
#  user_2_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_1_seen :boolean          default("f")
#  user_2_seen :boolean          default("f")
#  pitcher_id  :integer
#  pitch_seen  :boolean          default("f")
#  locked      :boolean          default("t")
#
# Indexes
#
#  index_matches_on_pitcher_id  (pitcher_id)
#  index_matches_on_user_1_id   (user_1_id)
#  index_matches_on_user_2_id   (user_2_id)
#

FactoryGirl.define do
  factory :match do
    user_1_id 1
user_2_id 1
  end

end
