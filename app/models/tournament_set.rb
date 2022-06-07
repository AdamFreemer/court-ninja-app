# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_sets
#
#  id            :bigint           not null, primary key
#  court         :integer
#  ghost_players :integer          default(0)
#  number        :integer
#  round         :integer
#  zip           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :bigint
#
# Indexes
#
#  index_tournament_sets_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_id => tournaments.id)
#
class TournamentSet < ApplicationRecord
  belongs_to :tournament
  has_many :tournament_set_tournament_teams
  has_many :tournament_teams, through: :tournament_set_tournament_teams
  has_many :user_scores
end
