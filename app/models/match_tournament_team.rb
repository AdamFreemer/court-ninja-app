# frozen_string_literal: true

# == Schema Information
#
# Table name: match_tournament_teams
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  match_id           :bigint
#  tournament_team_id :bigint
#
# Indexes
#
#  index_match_tournament_teams_on_match_id            (match_id)
#  index_match_tournament_teams_on_tournament_team_id  (tournament_team_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (tournament_team_id => tournament_teams.id)
#
class MatchTournamentTeam < ApplicationRecord
  belongs_to :match
  belongs_to :tournament_team
end
