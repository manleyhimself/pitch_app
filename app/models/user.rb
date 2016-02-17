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

class User < ActiveRecord::Base

  def matches
    Match.where("user_1_id = ? OR user_2_id = ?", id, id)
  end

  def likes
    Like.where('(user_id = ?) OR (likee_id = ? AND match = ?)', id, id, true)
  end

  def likees # people you've liked
    joins_likes.where('(liker_likes.user_id = ?) OR (likee_likes.likee_id = ? AND likee_likes.match = ?)', id, id, true)
  end

  def inverse_likes
    Like.where('(likee_id = ?) OR (user_id = ? AND match = ?)', id, id, true)
  end

  def inverse_likees # people who have liked you
    joins_likes.where('(likee_likes.likee_id = ?) OR (liker_likes.user_id = ? AND liker_likes.match = ?)', id, id, true)
  end

  def matched_users
    joins_likes.where('(liker_likes.user_id = ? AND liker_likes.match = ?) OR (likee_likes.likee_id = ? AND likee_likes.match = ?)', id, true, id, true)
  end
  
  private

  def joins_likes
    User.joins("LEFT JOIN likes AS liker_likes ON users.id = liker_likes.likee_id")
      .joins("LEFT JOIN likes AS likee_likes ON users.id = likee_likes.user_id")
  end
end
