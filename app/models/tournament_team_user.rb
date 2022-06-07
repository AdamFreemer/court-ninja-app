# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_team_users
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tournament_team_id :bigint
#  user_id            :bigint
#
# Indexes
#
#  index_tournament_team_users_on_tournament_team_id  (tournament_team_id)
#  index_tournament_team_users_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_team_id => tournament_teams.id)
#  fk_rails_...  (user_id => users.id)
#
class TournamentTeamUser < ApplicationRecord
  belongs_to :user
  belongs_to :tournament_team
end
