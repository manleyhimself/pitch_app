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
      let!(:test_user) {base_user.update_attributes(lat: 40.887038, lng: -72.392294, interested_in: 1))}
      let!(:user_1) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 40.887028, lng: -72.392296) } # female, seeking_male, in radius
      let!(:user_2) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 40.884054, lng: -72.392290) } # female, seeking_male, in radius
      let!(:user_3) { FactoryGirl.create(:user, gender: 0, interested_in: 1, lat: 40.883054, lng: -72.392292) } # male, seeking_female, in radius
      let!(:user_4) { FactoryGirl.create(:user, gender: 1, interested_in: 0, lat: 40.822691, lng: -72.545011) } # female, seeking_male, NOT in radius
      let!(:user_5) { FactoryGirl.create(:user, gender: 1, interested_in: 1, lat: 40.887028, lng: -72.392296) } # female, seeking_female, in radius
      let!(:user_6) { FactoryGirl.create(:user, gender: 0, interested_in: 0, lat: 40.887028, lng: -72.392296) } # male, seeking_male, in radius
      describe 'feed_users' do
        it 'only returns compatible users within a set radius' do 
          expect(test_user.feed_users).to match_array(user_1, user_2)
        end
      end
    end
  end
end










