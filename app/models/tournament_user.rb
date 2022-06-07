# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_users
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_tournament_users_on_tournament_id  (tournament_id)
#  index_tournament_users_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tournament_id => tournaments.id)
#  fk_rails_...  (user_id => users.id)
#
class TournamentUser < ApplicationRecord
  belongs_to :tournament
  belongs_to :user
end
