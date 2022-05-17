# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  number        :integer
#  score         :integer
#  work_team     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :integer
#
class Team < ApplicationRecord
  belongs_to :tournament

  has_many :team_users
  has_many :users, through: :team_users

  has_many :match_teams
  has_many :matches, through: :match_teams

  has_many :user_scores

  def self.score_update(score_data)
    teams_count = score_data.length
    teams_count_array = [*0..teams_count - 1].map(&:to_s)
    teams_count_array.each do |team_number|
      team = score_data[team_number]
      team_lookup = Team.find_by(id: team['team_id'])
      puts "== team #{team_number}"
      next if team_lookup.work_team == true

      team_lookup.update(score: team['score'])
    end
  end
end
