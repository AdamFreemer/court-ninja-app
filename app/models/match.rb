# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  court         :integer
#  ghost_players :integer          default(0)
#  number        :integer
#  round         :integer
#  zip           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :integer
#
class Match < ApplicationRecord
  belongs_to :tournament
  has_many :match_tournament_teams
  has_many :tournament_teams, through: :match_tournament_teams
  has_many :user_scores
end
