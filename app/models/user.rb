class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tournament_users
  has_many :tournaments, through: :tournament_users

  has_many :team_users
  has_many :teams, through: :team_users

  has_many :user_traits
  has_many :traits, through: :user_traits

  has_many :user_scores

  def full_name
    "#{last_name}, #{first_name}"
  end

  def name_abbreviated
    if is_ghost_player
      '--'
    else
      "#{first_name.capitalize} #{last_name[0].capitalize}"
    end
  end
end
