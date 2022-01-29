# frozen_string_literal: true

class QcTournament < ApplicationRecord
  has_many :qc_matches

  has_many :users, through: :qc_tournament_users
  has_many :qc_tournament_users
end
