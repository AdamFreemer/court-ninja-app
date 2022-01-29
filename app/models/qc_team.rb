# frozen_string_literal: true

class QcTeam < ApplicationRecord
  has_many :users, through: :qc_team_users
  has_many :qc_team_users
end
