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

class User < ActiveRecord::Base

  # gender/interested_in: 0 => male, 1 => female
  enum gender: [:male, :female]
  enum interested_in: [:seeking_male, :seeking_female]

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  def matches
    Match.where("user_1_id = ? OR user_2_id = ?", id, id)
  end

  def likes
    Like.where('(user_id = ?) OR (likee_id = ? AND match = ?)', id, id, true)
  end

  def likees # users you've liked
    joins_likes.where('(liker_likes.user_id = ?) OR (likee_likes.likee_id = ? AND likee_likes.match = ?)', id, id, true)
  end

  def inverse_likes #users who like you
    Like.where('(likee_id = ?) OR (user_id = ? AND match = ?)', id, id, true)
  end

  def inverse_likees # users who have liked you
    joins_likes.where('(likee_likes.likee_id = ?) OR (liker_likes.user_id = ? AND liker_likes.match = ?)', id, id, true)
  end

  def matched_users
    joins_likes.where('(liker_likes.user_id = ? AND liker_likes.match = ?) OR (likee_likes.likee_id = ? AND likee_likes.match = ?)', id, true, id, true)
  end
  
  def feed_users radius
    User.within(radius, origin: [lat, lng])
      .where(interested_in: User.genders[gender], gender: User.interested_ins[interested_in])
      .where.not(id: all_users_through_likes.pluck(:id)) #TODO when optimizing, figure out how to make this all happen in one query
  end

  def recent_inverse_likees seen_this_session_ids # Users with likes where match=f and likee_seen_count < 3
    inverse_likees
      .where.not(id: seen_this_session_ids)
      .where('likee_likes.match = ? AND likee_likes.likee_id = ? AND likee_likes.likee_seen_count < ?', false, id, 3)
  end

  def all_users_through_likes # returns all users who you have liked or have liked you
    joins_likes.where('(likee_likes.likee_id = ?) OR (liker_likes.user_id = ?)', id, id)
  end

  private

  def joins_likes
    User.joins("LEFT JOIN likes AS liker_likes ON users.id = liker_likes.likee_id")
      .joins("LEFT JOIN likes AS likee_likes ON users.id = likee_likes.user_id")
  end
end
