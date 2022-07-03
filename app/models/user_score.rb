# == Schema Information
#
# Table name: user_scores
#
#  id                 :bigint           not null, primary key
#  court              :integer
#  loss               :integer
#  round              :integer
#  score              :integer
#  win                :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tournament_id      :bigint
#  tournament_set_id  :bigint
#  tournament_team_id :bigint
#  user_id            :bigint
#
# Indexes
#
#  index_user_scores_on_tournament_id       (tournament_id)
#  index_user_scores_on_tournament_set_id   (tournament_set_id)
#  index_user_scores_on_tournament_team_id  (tournament_team_id)
#  index_user_scores_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_id => tournaments.id)
#  fk_rails_...  (tournament_set_id => tournament_sets.id)
#  fk_rails_...  (tournament_team_id => tournament_teams.id)
#  fk_rails_...  (user_id => users.id)
#
class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :tournament_team
  belongs_to :tournament_set
  belongs_to :tournament
end
