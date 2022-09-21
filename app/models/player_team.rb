# == Schema Information
#
# Table name: player_teams
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :bigint
#  team_id    :bigint
#
# Indexes
#
#  index_player_teams_on_player_id  (player_id)
#  index_player_teams_on_team_id    (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => users.id)
#  fk_rails_...  (team_id => teams.id)
#
class PlayerTeam < ApplicationRecord
  belongs_to :player, class_name: 'User'
  belongs_to :team

  validates :team_id, uniqueness: { scope: :player_id }
end
