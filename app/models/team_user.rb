# frozen_string_literal: true

# == Schema Information
#
# Table name: team_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#  user_id    :integer
#
class TeamUser < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
