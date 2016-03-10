# == Schema Information
#
# Table name: likes
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  likee_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  match            :boolean          default("false")
#  match_time       :datetime
#  likee_seen_count :integer          default("0")
#
# Indexes
#
#  index_likes_on_likee_id  (likee_id)
#  index_likes_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { FactoryGirl.create(:user, gender: 0) }

  describe 'user liking' do
    let!(:base_user) { FactoryGirl.create(:user, gender: 0) }
    let!(:target_user) { FactoryGirl.create(:user, gender: 1) }

    it 'creates a new like if the base user has not been liked by the target user' do
      before_like_count = Like.count
      Like.create_or_update(base_user_id: base_user.id, target_user_id: target_user.id)
      expect(Like.count).to eq(before_like_count + 1)
    end

    it 'it does not create a new like if the base user has already been liked by the target user' do 
      Like.create_or_update(base_user_id: target_user.id, target_user_id: base_user.id)
      before_like_count = Like.count
      Like.create_or_update(base_user_id: base_user.id, target_user_id: target_user.id)
      expect(Like.count).to eq(before_like_count)
    end

    it 'returns a like with match set to false if the base user has not been liked by the target user' do
      like = Like.create_or_update(base_user_id: base_user.id, target_user_id: target_user.id)
      expect(like.match?).to be(false)
    end

    it 'returns a like with match set to true if the base user has been liked by the target user' do 
      Like.create_or_update(base_user_id: target_user.id, target_user_id: base_user.id)
      like = Like.create_or_update(base_user_id: base_user.id, target_user_id: target_user.id)
      expect(like.match?).to be(true)
    end

  end
  
end
