# frozen_string_literal: true

class QcTeamUser < ApplicationRecord
  belongs_to :user
  belongs_to :qc_team
end
