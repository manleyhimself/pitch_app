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

class Match < ActiveRecord::Base
  #has_many :messages

  def self.seen user_id
    user_seen_query(user_id, true)
  end

  def self.unseen user_id
    user_seen_query(user_id, false)
  end

  def self.unseen_and_pitches user_id
    where("#{user_seen_query_str} OR (pitcher_id != ? AND pitcher_id IS NOT NULL AND pitch_seen = ?)", user_id, false, user_id, false, user_id, false)
  end

  def pitched?
    pitcher_id.present?
  end

  def seen! user_id
    self.send("#{foreign_prefix(user_id)}_seen=", true)
    self.save
  end

  def seen? user_id
    self.send("#{foreign_prefix(user_id)}_seen?")
  end

  private

  def self.user_seen_query user_id, seen_bool
    where("#{user_seen_query_str}", user_id, seen_bool, user_id, seen_bool)
  end

  def self.user_seen_query_str
    "(user_1_id = ? AND user_1_seen = ?) OR (user_2_id = ? AND user_2_seen = ?)"
  end

  def foreign_prefix user_id
    user_1_id == user_id ? "user_1" : "user_2"
  end
end
