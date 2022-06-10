# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  city                   :string
#  contact_1_address      :string
#  contact_1_name         :string
#  contact_1_phone        :string
#  contact_2_address      :string
#  contact_2_name         :string
#  contact_2_phone        :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  is_ghost_player        :boolean          default(FALSE)
#  jersey_number          :string
#  last_name              :string
#  phone_number           :string
#  position               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
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
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :tournament_users, dependent: :destroy
  has_many :tournaments, through: :tournament_users

  has_many :tournament_team_users, dependent: :destroy
  has_many :tournament_teams, through: :tournament_team_users

  has_many :user_traits, dependent: :destroy
  has_many :traits, through: :user_traits

  has_many :user_scores, dependent: :destroy

  attr_accessor :role

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
