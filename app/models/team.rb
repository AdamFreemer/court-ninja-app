# == Schema Information
#
# Table name: teams
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  description :text
#  invite_code :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  coach_id    :bigint
#
# Indexes
#
#  index_teams_on_coach_id  (coach_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_id => users.id)
#
class Team < ApplicationRecord
  after_create :generate_invite_code

  belongs_to :coach, class_name: 'User', inverse_of: :teams_coached

  has_many :player_teams, dependent: :destroy
  has_many :players, through: :player_teams

  scope :active, -> { where(active: true) }
  validates :invite_code, uniqueness: { scope: :active } # rubocop:disable Rails/UniqueValidationWithoutIndex

  def generate_invite_code
    code = [*('A'..'Z'), *('0'..'9')].sample(6).join
    update!(invite_code: code)
  rescue StandardError => e
    Rails.logger.info(e)
    generate_invite_code
  end
end
