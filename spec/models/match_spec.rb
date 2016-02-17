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

require 'rails_helper'

RSpec.describe Match, type: :model do

   let(:user_1) { FactoryGirl.create(:user) }
   let(:user_2) { FactoryGirl.create(:user) }
   let!(:match) { FactoryGirl.create(:match, user_1_id: user_1.id, user_2_id: user_2.id) }
  
  describe 'class methods' do 

    describe 'self.seen' do
      it 'returns seen matches for a specific user_id' do
        match.update(user_1_seen: true)
        expect(Match.seen(user_1.id).first).to eq(match)
      end
    end
    
    describe 'self.unseen' do
      it 'returns unseen matches for a specific user_id' do
        expect(Match.unseen(user_1.id).first).to eq(match)
      end
    end

    describe 'self.unseen_and_pitches' do
      it 'returns unseen matches for a specific user_id' do
        expect(Match.unseen_and_pitches(user_1.id).first).to eq(match)
      end
      it 'returns a match where a user has seen the match, but not the pitch and the user is not the pitcher' do
        match.update(user_1_seen: true, pitcher_id: user_2.id)
        expect(Match.unseen_and_pitches(user_1.id).first).to eq(match)
      end
      it 'returns distinct matches where a user has not seen the match or the pitch and the user is not the pitcher' do
        match.update(user_1_seen: false, pitcher_id: user_2.id)
        expect(Match.unseen_and_pitches(user_1.id).length).to eq(1)
      end
      it 'does not return matches where a user has seen the match and the user is the pitcher' do
        match.update(user_1_seen: true, user_2_seen: true, pitcher_id: user_1.id)
        expect(Match.unseen_and_pitches(user_1.id).length).to eq(0)
      end
      it 'does not return matches where a user has seen the match and the pitch and the user is not the pitcher' do
        match.update(user_1_seen: true, pitcher_id: user_2.id, pitch_seen: true)
        expect(Match.unseen_and_pitches(user_1.id).length).to eq(0)
      end
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









