# frozen_string_literal: true

# == Schema Information
#
# Table name: tournaments
#
#  id                   :bigint           not null, primary key
#  address1             :string
#  address2             :string
#  adhoc                :boolean          default(FALSE)
#  break_time           :decimal(5, 1)
#  city                 :string
#  configuration        :string
#  court_1_name         :string
#  court_2_name         :string
#  court_3_name         :string
#  court_4_name         :string
#  court_5_name         :string
#  court_6_name         :string
#  court_names          :string           default([]), is an Array
#  court_side_a_name    :string
#  court_side_b_name    :string
#  courts               :integer
#  current_round        :integer          default(0)
#  current_set          :integer          default(1)
#  date                 :datetime
#  name                 :string
#  players              :integer          default([]), is an Array
#  rounds               :integer
#  rounds_configured    :integer          default([]), is an Array
#  rounds_finalized     :integer          default([]), is an Array
#  state                :string
#  team_size            :integer
#  timer_mode           :string           default("break")
#  timer_state          :string           default("initial")
#  timer_time           :integer          default(0)
#  tournament_completed :boolean          default(FALSE)
#  tournament_time      :decimal(5, 1)
#  work_group           :integer
#  zip                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  created_by_id        :bigint
#
# Indexes
#
#  index_tournaments_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Tournament < ApplicationRecord
  belongs_to :created_by, class_name: 'User', inverse_of: :tournaments_run

  has_many :tournament_teams
  has_many :tournament_sets
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :user_scores

  scope :before_today, -> { where("created_at < ?", 1.days.ago) }
  scope :today, -> { where("created_at > ?", DateTime.now.beginning_of_day) }

  after_save :associate_players

  def generate
    return false unless players.count.between?(6, 27)
    return false if current_round == 1 && players.count.between?(6, 9)

    ordered_player_ids = if self.current_round == 0 # new tournament, just use newly created self.players
                           players
                         else                       # self.player_ranking returns ranked court array
                          PlayerConfigs.player_court_distributor(player_ranking(self.current_round), players)
                         end
    round = TournamentGenerator.new(self, ordered_player_ids)
    round.generate_round(current_round + 1)
  end

  def create_user_scores(round)
    # this method is non-idempotent
    tournament_sets.where(round: round).each do |tournament_set|
      score = scoring(tournament_set)
      tournament_set.tournament_teams.each do |team|
        next if team.work_team

        team.users.each do |user|
          user.user_scores.create(
            tournament_id: tournament_set.tournament.id,
            tournament_set_id: tournament_set.id, tournament_team_id: team.id,
            court: tournament_set.court, round: tournament_set.round,
            score: team.number == 1 ? score[:team1][:score] : score[:team2][:score],
            win: team.number == 1 ? score[:team1][:win] : score[:team2][:win],
            loss: team.number == 1 ? score[:team1][:loss] : score[:team2][:loss]
          )
        end
      end
    end
  end

  def court_names_pretty
    courts = []
    courts << court_1_name if court_1_name
    courts << ", #{court_2_name}" if court_2_name.present?
    courts << ", #{court_3_name}" if court_3_name.present?
    courts << ", #{court_4_name}" if court_4_name.present?
    courts << ", #{court_5_name}" if court_5_name.present?
    courts << ", #{court_6_name}" if court_6_name.present?

    courts.join
  end

  def player_ranking(round)
    # This method is idempotent
    court_1_scores = []; court_2_scores = []; court_3_scores = []; court_4_scores = []; court_5_scores = []; court_6_scores = []
    players = User.where(id: users)
    players.each do |player|
      next if player.is_ghost_player == true

      score = player.user_scores.where(tournament_id: id, round: round).sum(:score)
      wins = player.user_scores.where(tournament_id: id, round: round).sum(:win)   

      if player.user_scores.where(tournament_id: id, round: round, court: 1).count.positive?
        court_1_scores << [player.id, player.name_abbreviated, score, wins]
      end
      if player.user_scores.where(tournament_id: id, round: round, court: 2).count.positive?
        court_2_scores << [player.id, player.name_abbreviated, score, wins]
      end
      if player.user_scores.where(tournament_id: id, round: round, court: 3).count.positive?
        court_3_scores << [player.id, player.name_abbreviated, score, wins]
      end     
      if player.user_scores.where(tournament_id: id, round: round, court: 4).count.positive?
        court_4_scores << [player.id, player.name_abbreviated, score, wins]
      end   
      if player.user_scores.where(tournament_id: id, round: round, court: 5).count.positive?
        court_5_scores << [player.id, player.name_abbreviated, score, wins]
      end 
      if player.user_scores.where(tournament_id: id, round: round, court: 6).count.positive?
        court_6_scores << [player.id, player.name_abbreviated, score, wins]
      end 
    end

    court_1_sorted = normalized_score(court_1_scores.sort_by { |a| [-a[3], -a[2]] }) 
    court_2_sorted = normalized_score(court_2_scores.sort_by { |a| [-a[3], -a[2]] })
    courts >= 3 ? court_3_sorted = normalized_score(court_3_scores.sort_by { |a| [-a[3], -a[2]] }) : court_3_sorted = []
    courts >= 4 ? court_4_sorted = normalized_score(court_4_scores.sort_by { |a| [-a[3], -a[2]] }) : court_4_sorted = []
    courts >= 5 ? court_5_sorted = normalized_score(court_5_scores.sort_by { |a| [-a[3], -a[2]] }) : court_5_sorted = []
    courts == 6 ? court_6_sorted = normalized_score(court_6_scores.sort_by { |a| [-a[3], -a[2]] }) : court_6_sorted = []

    [court_1_sorted, court_2_sorted, court_3_sorted, court_4_sorted, court_5_sorted, court_6_sorted]
  end

  def normalized_score(court_sorted)
    # this method raises the score floor to 1, to eliminate negative scores being displayed
    lowest_score = court_sorted.collect { |arr| arr[2] }.min
    return [] if court_sorted == []
    return court_sorted unless lowest_score.negative?

    court_sorted.each do |player|
      player[2] = player[2] + lowest_score&.abs + 1
    end
  end



  def scoring(tournament_set)
    # TODO: handle nil scores
    team_1_score = tournament_set.tournament_teams.find_by(number: 1).score ||= 0
    team_2_score = tournament_set.tournament_teams.find_by(number: 2).score ||= 0
    score_delta = (team_1_score - team_2_score).abs

    if team_1_score > team_2_score
      {
        team1: { win: 1, loss: 0, score: score_delta },
        team2: { win: 0, loss: 1, score: -score_delta }
      }
    else
      {
        team1: { win: 0, loss: 1, score: -score_delta },
        team2: { win: 1, loss: 0, score: score_delta }
      }
    end
  end

  def update_current_set(score_data)
    teams_count = score_data.length
    teams_count_array = [*0..teams_count - 1].map(&:to_s)
    found_current = false
    teams_count_array.each do |team_number|
      break if found_current

      if score_data[team_number]['score'] == ''
        no_score_team = TournamentTeam.find(score_data[team_number][:team_id])
        current_set = no_score_team.tournament_sets.first.number
        # if we find a blank score, we update tournament.current_set and mark found_current
        # which will break out of loop on next pass
        update(current_set: current_set, timer_state: "run")
        found_current = true
      end
    end
    # if we find no empty scores, set current_set so no rows are highlighted
    update(current_set: 0) if found_current == false
  end

  def self.sanitized_of_ghosts_players(player_ids)
    ghost_users_ids = User.where(is_ghost_player: true).collect(&:id)
    player_ids.map(&:to_i) - ghost_users_ids
  end

  private

  def associate_players
    self.users = []
    players.each do |player|
      self.users << User.find(player)
    end
  end
end
