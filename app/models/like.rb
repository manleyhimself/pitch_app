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

class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :likee, class: User

  # this method assumes that, elsewhere, we prevent users from liking the same user twice
  # -OR- periodically clear the un-matched likes 
  def self.create_or_update base_user_id: nil, target_user_id: nil
    inverse_like = find_inverse_like(base_user_id: base_user_id, target_user_id: target_user_id)

    if inverse_like.present?
      inverse_like.update_attributes(match: true, match_time: Time.now)
      inverse_like
    else
      create(user_id: base_user_id, likee_id: target_user_id)
    end
  end

  def self.find_inverse_like base_user_id: nil, target_user_id: nil
    where(user_id: target_user_id, likee_id: base_user_id).first
  end
  
end
