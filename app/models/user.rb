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
  has_many :likes

  # has_many :likees, through: :likes #users self has liked
  # has_many :inverse_likes, class_name: "Like", foreign_key: "likee_id" 
  # has_many :inverse_likees, through: :inverse_likes, source: :user #users who have liked self

  def likes
    Like.where('(user_id = ?) OR (likee_id = ? AND match = ?)', id, id, true)
  end

  def likees # people you've liked
    User.joins(:likes)
      .where('(likes.user_id = ?) OR (likes.likee_id = ? AND likes.match = ?)', id, id, true)
      #(likes.user_id = ?) -> find rows in likes table with user_id and return users through likee_id
      #(likes.likee_id = ? AND likes.match = ?) -> find rows in likes table with likee_id and return users through user_id

      # TODO: problem is that when following like is found, Like(user_id: self.id, likee_id: other_user.id), 
        # it is returning user through user_id rather than likee_id. Therefore, we are returning self.
  end

  def inverse_likes
    Like.where('(likee_id = ?) OR (user_id = ? AND match = ?)', id, id, true)
  end

  def inverse_likees
    User.joins(:likes)
      .where('(likes.likee_id = ?) OR (likes.user_id = ? AND likes.match = ?)', id, id, true)
  end

  def matches
    User.joins(:likes)
      .where('(likes.user_id = ? AND likes.match = ?) OR (likes.likee_id = ? AND likes.match = ?)', id, true, id, true)
  end
  
end
