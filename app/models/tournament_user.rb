# frozen_string_literal: true

class TournamentUser < ApplicationRecord
  belongs_to :tournament
  belongs_to :user
end
