# frozen_string_literal: true

# == Schema Information
#
# Table name: match_teams
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :integer
#  team_id    :integer
#
class MatchTeam < ApplicationRecord
  belongs_to :match
  belongs_to :team
end
