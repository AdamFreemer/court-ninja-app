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
  # after_create :generate_invite_code
  # validates :invite_code, uniqueness: { scope: :active } # rubocop:disable Rails/UniqueValidationWithoutIndex
  # belongs_to :user
  # belongs_to :tournament
  has_many :player_teams, dependent: :destroy
  has_many :players, through: :player_teams

  scope :active, -> { where(active: true) }

  def update_players(params)
    players_selected = params[:team][:players].reject(&:empty?).collect(&:to_i)

    return if self.players == players_selected

    self.players.clear
    players_selected.each do |player|
      team_player = User.find(player)
      self.players << team_player
    end
    self.save!
  end

  def display_configuration
    case players.count

    when 4
      'Doubles, 1 court, 3 matches, no bystanders'
    when 5
      'Doubles, 1 court, 5 matches, 1 bystander'
    when 6
      'Triples, 1 court, 10 matches, no bystanders'
    when 7
      'Triples, 1 court, 7 matches, 1 bystander'
    when 8
      'Triples, 1 court, 8 matches, 2 bystanders'
    when 9
      'Triples, 1 court, 9 matches, 3 bystanders'
    when 10
      'Doubles 2 courts, 10 matches, 2 bystanders'
    when 11
      'Doubles, 2 courts, 11 matches, 3 bystanders'
    when 12
      'Triples, 2 courts, 11 matches, no bystanders'
    when 13
      'Triples, 2 courts, 13 matches, 1 bystander'
    when 14
      'Triples, 2 courts, 14 matches, 2 bystanders'
    when 15
      'Triples, 2 courts, 10 matches, 3 bystanders'
    end
  end

  def generate_invite_code
    code = [*('A'..'Z'), *('0'..'9')].sample(6).join
    update!(invite_code: code)
  rescue StandardError => e
    Rails.logger.info(e)
    generate_invite_code
  end
end
