# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  first_name    :string
#  last_name     :string
#  full_name     :string
#  gender        :integer
#  password      :string
#  university    :string
#  job_title     :string
#  company_name  :string
#  blurb         :string
#  birthday      :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lat           :float
#  lng           :float
#  interested_in :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryGirl.create(:user, gender: 0) }

  describe 'single-row like and match associations' do
    let!(:base_user) { FactoryGirl.create(:user, gender: 0) }
    let!(:target_user) { FactoryGirl.create(:user, gender: 1) }
    let!(:base_like) { FactoryGirl.create(:like, user_id: base_user.id, likee_id: target_user.id) }

    describe 'return the likes that indicate a user has liked another user' do 
      it 'returns likes where the user\'s id is set to likes.user_id' do
        expect(base_user.likes.length).to eq(1)
        expect(base_user.likes.first).to eq(base_like)
      end

      it 'returns likes when the user\'s id is set to likes.likee_id and likes.match is true' do
        base_like.update_attributes(match: true)

        expect(target_user.likes.length).to eq(1)
        expect(target_user.likes.first).to eq(base_like)
      end

      it 'will not return likes when the user\'s id is set to likes.likee_id and likes.match is false' do
        base_like.update_attributes(match: false)

        expect(target_user.likes.length).to eq(0)
      end
    end

    describe 'return the likes that indicate a user has been liked by another user' do
      it 'returns likes where the user\'s id is set to likes.likee_id' do
        expect(target_user.inverse_likes.length).to eq(1)
        expect(target_user.inverse_likes.first).to eq(base_like)
      end

      it 'returns likes when the user\'s id is set to likes.user_id and matches is true' do
        base_like.update_attributes(match: true)

        expect(base_user.inverse_likes.length).to eq(1)
        expect(base_user.inverse_likes.first).to eq(base_like)
      end

      it 'will not return likes when the user\'s id is set to likes.user_id and matches is false' do
        base_like.update_attributes(match: false)

        expect(base_user.inverse_likes.length).to eq(0)
      end
    end

    describe 'return the users that a user has liked' do 
      it 'returns users through likes.likee_id where likes.user_id is the user\'s id' do
        expect(base_user.likees.length).to eq(1)
        expect(base_user.likees.first).to eq(target_user)
      end 

      it 'returns users through likes.user_id where likes.likee_id is the user\'s id and likes.match is true' do
        base_like.update_attributes(match: true)

        expect(target_user.likees.length).to eq(1)
        expect(target_user.likees.first).to eq(base_user)
      end

      it 'returns nil when likes.likee_id is the user\'s id and likes.match is false' do
        base_like.update_attributes(match: false)

        expect(target_user.likees.length).to eq(0)
      end
    end


    describe 'return users who have liked a user' do

      it 'returns users through likes.user_id where likes.likee_id is the user\'s id' do 
        expect(target_user.inverse_likees.length).to eq(1)
        expect(target_user.inverse_likees.first).to eq(base_user)
      end

      it 'returns users through likes.likee_id where likes.user_id is the user\'s id and likes.match is true' do 
        base_like.update_attributes(match: true)

        expect(base_user.inverse_likees.length).to eq(1)
        expect(base_user.inverse_likees.first).to eq(target_user)
      end

      it 'returns nil when likes.user_id is the user\'s id and likes.match is false' do 
        base_like.update_attributes(match: false)

        expect(base_user.inverse_likees.length).to eq(0)
      end

    end

    describe 'returns users that user has matched with' do 
      
      it 'returns users through likes.likee_id where likes.user_id is the user\'s id, and match is true' do
        base_like.update_attributes(match: true)

        expect(base_user.matched_users.length).to eq(1)
        expect(base_user.matched_users.first).to eq(target_user)
      end    

      it 'returns users through likes.user_id where likes.likee_id is the user\'s id, and match is true' do
        base_like.update_attributes(match: true)

        expect(target_user.matched_users.length).to eq(1)
        expect(target_user.matched_users.first).to eq(base_user)
      end 

      it 'returns nil when likes.user_id is the user\'s id, and match is false' do
        base_like.update_attributes(match: false)

        expect(base_user.matched_users.length).to eq(0)
      end

      it 'returns nil when likes.likee_id is the user\'s id, and match is false' do
        base_like.update_attributes(match: false)

        expect(target_user.matched_users.length).to eq(0)
      end

    end

    describe 'instance methods' do
      describe '.matches' do
        let!(:match) { FactoryGirl.create(:match, user_1_id: base_user.id, user_2_id: target_user.id) }

        it 'returns matches where user\'s id is set as user_1_id or user_2_id' do 
          expect(base_user.matches.first).to eq(match)
        end
      end
    end

    describe 'feed methods' do 
      let!(:test_user) {FactoryGirl.create(:user, gender: 0, interested_in: 1, lat: 40.887038, lng: -72.392294)}
      let!(:unlikeable_user) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 40.887028, lng: -72.392296) } # female, seeking_male, in radius
      let!(:user_2) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 40.884054, lng: -72.392290) } # female, seeking_male, in radius, but like exists
      let!(:user_3) { FactoryGirl.create(:user, gender: 0, interested_in: 1, lat: 40.883054, lng: -72.392292) } # male, seeking_female, in radius
      let!(:user_4) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 39.954686, lng: -87.678447) } # female, seeking_male, NOT in radius
      let!(:user_5) { FactoryGirl.create(:user, gender: 1, interested_in: 1, lat: 40.887028, lng: -72.392296) } # female, seeking_female, in radius
      let!(:user_6) { FactoryGirl.create(:user, gender: 0, interested_in: 0, lat: 40.887031, lng: -72.392296) } # male, seeking_male, in radius
      let!(:like_1) { FactoryGirl.create(:like, user_id: test_user.id, likee_id: user_2.id) } 
      let!(:like_2) { FactoryGirl.create(:like, user_id: user_4.id, likee_id: test_user.id) } 
      let!(:like_3) { FactoryGirl.create(:like, user_id: user_5.id, likee_id: test_user.id) } 
      
      describe 'feed_users' do
        it 'only returns compatible users within a set radius' do
          expect(test_user.feed_users(5)).to match_array([unlikeable_user])
        end

        it 'will not return users that the target user has already liked' do
          FactoryGirl.create(:like, user_id: test_user.id, likee_id: unlikeable_user.id)
          expect(test_user.feed_users(5).empty?).to be(true)
        end

        it 'will not returns users who have liked you' do
          FactoryGirl.create(:like, user_id: unlikeable_user.id, likee_id: test_user.id)
          expect(test_user.feed_users(5).empty?).to be(true)
        end

        it 'does not break if base user has not liked anyone yet' do
          test_user.likes.delete_all
          expect(test_user.feed_users(5)).to match_array([unlikeable_user, user_2])
        end
      end
      describe 'recent_inverse_likees' do
        it 'returns users that have liked a user, where a match does\'t exist' do
          expect(test_user.recent_inverse_likees([])).to match_array([user_4, user_5])
        end

        it 'appropriately removes users who\'s ids are passsed into the method' do
          expect(test_user.recent_inverse_likees([user_4.id])).to match_array([user_5])
        end

        it 'removes users from the query who are matched with a user' do 
          like_3.update_attributes(match: true)
          expect(test_user.recent_inverse_likees([])).to match_array([user_4])
        end

      end
    end
  end
end










