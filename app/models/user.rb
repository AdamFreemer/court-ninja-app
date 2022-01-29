class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :qc_tournaments, through: :qc_tournament_users
  has_many :qc_tournament_users

  has_many :qc_teams, through: :qc_team_users
  has_many :qc_team_users

  has_many :attributes, through: :user_attributes
  has_many :user_attributes
end
