# frozen_string_literal: true

# == Schema Information
#
# Table name: tournament_users
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tournament_id :integer
#  user_id       :integer
#
class TournamentUser < ApplicationRecord
  belongs_to :tournament
  belongs_to :user
end
