# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_teams
#
#  id            :bigint           not null, primary key
#  court         :integer
#  number        :integer
#  round         :integer
#  score         :integer
#  work_team     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :bigint
#
# Indexes
#
#  index_tournament_teams_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_id => tournaments.id)
#
class TournamentTeam < ApplicationRecord
  belongs_to :tournament

  has_many :tournament_team_users
  has_many :users, through: :tournament_team_users

  has_many :tournament_set_tournament_teams
  has_many :tournament_sets, through: :tournament_set_tournament_teams

  has_many :user_scores

  def self.score_update(score_data)
    teams_count = score_data.length
    teams_count_array = [*0..teams_count - 1].map(&:to_s)
    teams_count_array.each do |team_number|
      team = score_data[team_number]
      team_lookup = TournamentTeam.find_by(id: team['team_id'])
      next if team_lookup.work_team == true

      team_lookup.update(score: team['score'])
    end
  end
end
