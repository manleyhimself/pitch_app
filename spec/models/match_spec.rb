# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  user_1_id     :integer
#  user_2_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_1_seen   :boolean
#  user_2_seen   :boolean
#  pitcher_id_id :integer
#  pitch_seen    :boolean
#  locked        :boolean
#
# Indexes
#
#  index_matches_on_pitcher_id_id  (pitcher_id_id)
#  index_matches_on_user_1_id      (user_1_id)
#  index_matches_on_user_2_id      (user_2_id)
#

require 'rails_helper'

RSpec.describe Match, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
