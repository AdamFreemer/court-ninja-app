# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  adhoc                  :boolean          default(FALSE)
#  city                   :string
#  confirmation_token     :string
#  contact_1_address      :string
#  contact_1_name         :string
#  contact_1_phone        :string
#  contact_2_address      :string
#  contact_2_name         :string
#  contact_2_phone        :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  is_active              :boolean          default(TRUE)
#  is_admin               :boolean          default(FALSE)
#  is_coach               :boolean          default(FALSE)
#  is_ghost_player        :boolean          default(FALSE)
#  is_on_leaderboard      :boolean          default(TRUE)
#  is_one_off             :boolean          default(FALSE)
#  is_player              :boolean          default(FALSE)
#  jersey_number          :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  nick_name              :string
#  phone_number           :string
#  position               :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  state                  :string
#  subscribed             :boolean          default(FALSE)
#  subscription_plan      :integer          default(0)
#  subscription_status    :string
#  unlock_token           :string
#  zip                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  coach_id               :bigint
#  stripe_id              :integer
#  team_id                :integer
#
# Indexes
#
#  index_users_on_coach_id              (coach_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (coach_id => users.id)
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable, :trackable, :registerable#, :rememberable

  has_many :tournament_users, dependent: :destroy
  has_many :tournaments, through: :tournament_users

  has_many :tournament_team_users, dependent: :destroy
  has_many :tournament_teams, through: :tournament_team_users

  has_many :user_traits, dependent: :destroy
  has_many :traits, through: :user_traits

  has_many :player_teams, dependent: :destroy, foreign_key: :player_id
  has_many :teams, through: :player_teams

  has_many :user_scores, dependent: :destroy

  has_many :tournaments_run, foreign_key: :created_by_id, dependent: :nullify, class_name: 'Tournament'

  has_one_attached :profile_picture

  ##### player functionality #######
  has_many :players, class_name: 'User', foreign_key: 'coach_id'

  belongs_to :coach, class_name: 'User', optional: true
  ##################################

  attr_accessor :role, :invite_code

  before_save :resolve_email

  # Associations
  has_many :teams, foreign_key: 'coach_id'
  alias_method :teams_coached, :teams  # This creates teams_coached as an alias for teams

  # Or alternatively, you could define it as a method:
  def teams_coached
    teams
  end

  def is_coach?
    role == 'coach'  # Adjust this based on how you're tracking user roles
  end

  def is_admin?
    role == 'admin'  # Adjust this based on how you're tracking user roles
  end

  def full_name
    "#{last_name}, #{first_name}"
  end

  def full_name_proper
    "#{first_name} #{last_name}"
  end

  def initials
    if is_ghost_player
      ''
    elsif adhoc
      "#{nick_name[0]}"
    else
      "#{first_name[0]}#{last_name[0]}"
    end
  end

  def type
    if is_admin?
      'Admin'
    elsif is_coach?
      'Coach'
    else
      'Player'
    end
  end

  def statistics
    sets_played = user_scores.count
    sets_won = user_scores.sum(:win)
    sets_win_ratio = (Float(sets_won) / Float(sets_played)).round(2)

    tournaments_played = tournaments.count
    tournaments_won = tournaments.map(&:winner_id).count(id)
    tournaments_won_ratio = (Float(tournaments_won) / Float(tournaments_played)).round(2)

    {
      sets_played: sets_played,
      sets_won: sets_won,
      sets_win_ratio: sets_win_ratio,
      tournaments_played: tournaments_played,
      tournaments_won: tournaments_won,
      tournaments_won_ratio: tournaments_won_ratio
    }
  end

  def tournaments_array
    tournaments = Tournament.where(created_by_id: id).map(&:id)
    output = if tournaments == []
               ' '
             else
               tournaments
             end
    output
  end

  def name_abbreviated
    if is_ghost_player
      'Ghost Player'
    elsif nick_name.present?
      nick_name.capitalize
    else
      "#{first_name&.capitalize} #{last_name[0]&.capitalize}"
    end
  end

  def resolve_email
    return if email.present?

    # If email is blank, stamp with current unix time (ms)
    update(email: "#{DateTime.now.strftime('%Q')}@mail.com", is_one_off: true)
  end
end
