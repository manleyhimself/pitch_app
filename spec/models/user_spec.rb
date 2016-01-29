# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  first_name   :string
#  last_name    :string
#  full_name    :string
#  gender       :string
#  password     :string
#  university   :string
#  job_title    :string
#  company_name :string
#  blurb        :string
#  birthday     :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  describe 'single-row like and match associations' do
    let(:base_user) { FactoryGirl.create(:user) }
    let(:target_user) { FactoryGirl.create(:user) }
    let(:base_like) { FactoryGirl.create(:like, user_id: base_user.id, likee_id: target_user.id) }

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
      
      it 'returns users through likes.likee_id where likes.user_id is the user\'s id, and match is true'
        base_like.update_attributes(match: true)

        expect(base_user.matches.length).to eq(1)
        expect(base_user.matches.first).to eq(target_user)
      end    

      it 'returns users through likes.user_id where likes.likee_id is the user\'s id, and match is true'
        base_like.update_attributes(match: true)

        expect(target_user.matches.length).to eq(1)
        expect(target_user.matches.first).to eq(base_user)
      end 

      it 'returns nil when likes.user_id is the user\'s id, and match is false'
        base_like.update_attributes(match: false)

        expect(base_user.matches.length).to eq(0)
      end

      it 'returns nil when likes.likee_id is the user\'s id, and match is false'
        base_like.update_attributes(match: false)

        expect(target_user.matches.length).to eq(0)
      end

    end

  end

end










