# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  adhoc                  :boolean          default(FALSE)
#  city                   :string
#  contact_1_address      :string
#  contact_1_name         :string
#  contact_1_phone        :string
#  contact_2_address      :string
#  contact_2_name         :string
#  contact_2_phone        :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  is_ghost_player        :boolean          default(FALSE)
#  jersey_number          :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  nick_name              :string
#  phone_number           :string
#  position               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  state                  :string
#  zip                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  has_many :tournament_users, dependent: :destroy
  has_many :tournaments, through: :tournament_users

  has_many :tournament_team_users, dependent: :destroy
  has_many :tournament_teams, through: :tournament_team_users

  has_many :user_traits, dependent: :destroy
  has_many :traits, through: :user_traits

  has_many :player_teams, dependent: :destroy, foreign_key: :player_id
  has_many :teams, through: :player_teams

  has_many :user_scores, dependent: :destroy

  has_many :teams_coached, foreign_key: :coach_id, dependent: :nullify, class_name: 'Team'

  has_many :tournaments_run, foreign_key: :created_by_id, dependent: :nullify, class_name: 'Tournament'

  validate :unique_nick_name

  attr_accessor :role, :invite_code

  def full_name
    "#{last_name}, #{first_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def name_abbreviated
    if is_ghost_player
      '--'
    elsif nick_name
      nick_name.capitalize
    else
      "#{first_name&.capitalize} #{last_name[0]&.capitalize}"
    end
  end


  def unique_nick_name
    saved_user = User.find(self.id)
    # Checking saved user nickname vs current pre-save for changes as it will cause dup in team_nick_names array below
    return true if adhoc == true || teams.blank? || nick_name.blank? || saved_user.nick_name.downcase == nick_name.downcase

    team_nick_names = (teams.first.players.collect(&:nick_name) - [nil]).map(&:downcase)
    errors.add(:nick_name, 'is not unique to your team.') if team_nick_names.include?(nick_name)
  end
end
