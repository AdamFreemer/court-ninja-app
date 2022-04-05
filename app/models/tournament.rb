# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :user_scores
end
