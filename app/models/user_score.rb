# == Schema Information
#
# Table name: user_scores
#
#  id            :bigint           not null, primary key
#  court         :integer
#  loss          :integer
#  round         :integer
#  score         :integer
#  win           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_id      :integer
#  team_id       :integer
#  tournament_id :integer
#  user_id       :integer
#
class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :match
  belongs_to :tournament
end
