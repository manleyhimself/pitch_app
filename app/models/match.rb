# == Schema Information
#
# Table name: matches
#
#  id         :integer          not null, primary key
#  user_1_id  :integer
#  user_2_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_matches_on_user_1_id  (user_1_id)
#  index_matches_on_user_2_id  (user_2_id)
#

class Match < ActiveRecord::Base
end
