class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :match
  belongs_to :tournament
end
