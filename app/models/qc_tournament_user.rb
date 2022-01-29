# frozen_string_literal: true

class QcTournamentUser < ApplicationRecord
  belongs_to :qc_tournament
  belongs_to :user
end
