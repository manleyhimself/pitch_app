# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  user_1_id     :integer
#  user_2_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_1_seen   :boolean          default("f")
#  user_2_seen   :boolean          default("f")
#  pitcher_id_id :integer
#  pitch_seen    :boolean          default("f")
#  locked        :boolean          default("t")
#
# Indexes
#
#  index_matches_on_pitcher_id_id  (pitcher_id_id)
#  index_matches_on_user_1_id      (user_1_id)
#  index_matches_on_user_2_id      (user_2_id)
#

require 'rails_helper'

RSpec.describe Match, type: :model do

   let!(:user_1) { FactoryGirl.create(:user) }
   let!(:user_2) { FactoryGirl.create(:user) }
   let!(:match) { FactoryGirl.create(:match, user_1_id: user_1.id, user_2_id: user_2.id) }
  
  describe 'class methods' do 

    it 'returns seen matches for a specific user_id' do
      match.update(user_1_seen: true)
      expect(Match.seen(user_1.id).first).to eq(match)
    end

    it 'returns unseen matches for a specific user_id' do
      expect(Match.un_seen(user_1.id).first).to eq(match)
    end

  end

  describe 'instance methods' do

    it 'given a user_id it updates the appropriate user_seen boolean' do
      match.seen!(user_1.id)
      expect(match.user_1_seen).to eq(true)
      expect(match.user_2_seen).to eq(false)
    end

    it 'returns a boolean indicating that the appropriate user has seen a match' do
      match.update(user_1_seen: true)
      expect(match.seen?(user_1.id)).to eq(true)
      expect(match.seen?(user_2.id)).to eq(false)
    end

  end

end









