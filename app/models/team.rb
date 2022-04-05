# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :tournament

  has_many :team_users
  has_many :users, through: :team_users

  has_many :match_teams
  has_many :matches, through: :match_teams

  has_many :user_scores
end
