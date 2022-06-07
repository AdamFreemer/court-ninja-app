# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_set_tournament_teams
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tournament_set_id  :bigint
#  tournament_team_id :bigint
#
# Indexes
#
#  index_tournament_set_tournament_teams_on_tournament_set_id   (tournament_set_id)
#  index_tournament_set_tournament_teams_on_tournament_team_id  (tournament_team_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_set_id => tournament_sets.id)
#  fk_rails_...  (tournament_team_id => tournament_teams.id)
#
class TournamentSetTournamentTeam < ApplicationRecord
  belongs_to :tournament_set
  belongs_to :tournament_team
end
