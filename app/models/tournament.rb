# frozen_string_literal: true

# == Schema Information
#
# Table name: tournaments
#
#  id                    :bigint           not null, primary key
#  address1              :string
#  address2              :string
#  adhoc                 :boolean          default(FALSE)
#  admin_view_current    :integer
#  admin_views           :json
#  break_time            :decimal(5, 1)
#  city                  :string
#  configuration         :string
#  court_1_name          :string
#  court_2_name          :string
#  court_3_name          :string
#  court_4_name          :string
#  court_5_name          :string
#  court_6_name          :string
#  court_names           :string           default([]), is an Array
#  court_side_a_name     :string
#  court_side_b_name     :string
#  courts                :integer
#  current_match         :integer          default(1)
#  current_matches       :json
#  current_round         :integer          default(0)
#  current_set           :integer          default(1)
#  date                  :datetime
#  is_new                :boolean          default(TRUE)
#  match_time            :integer
#  matches_per_round     :integer
#  name                  :string
#  players               :integer          default([]), is an Array
#  pre_match_time        :integer
#  rounds                :integer
#  rounds_configured     :integer          default([]), is an Array
#  rounds_finalized      :integer          default([]), is an Array
#  state                 :string
#  team_size             :integer
#  timer_mode            :string           default("break")
#  timer_state           :string           default("initial")
#  timer_time            :integer          default(0)
#  total_tournament_time :float
#  tournament_completed  :boolean          default(FALSE)
#  tournament_time       :decimal(5, 1)
#  work_group            :integer
#  zip                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  base_team_id          :bigint
#  created_by_id         :bigint
#  winner_id             :integer          default(0)
#
# Indexes
#
#  index_tournaments_on_base_team_id   (base_team_id)
#  index_tournaments_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (base_team_id => teams.id)
#  fk_rails_...  (created_by_id => users.id)
#
class Tournament < ApplicationRecord
  # rubocop:disable Lint/NumberConversion
  belongs_to :created_by, class_name: 'User', inverse_of: :tournaments_run
  belongs_to :base_team, class_name: 'Team', optional: true

  has_many :tournament_teams, dependent: :destroy
  has_many :tournament_sets, dependent: :destroy
  has_many :tournament_users, dependent: :destroy
  has_many :users, through: :tournament_users, dependent: :destroy
  has_many :user_scores, dependent: :destroy


  scope :before_today, -> { where("created_at < ?", 1.days.ago) }
  scope :today, -> { where("created_at > ?", DateTime.now.beginning_of_day) }

  # after_save :associate_players  #TODO: refactor to not hit db when not needed
  before_save :calculate_total_tournament_time

  def generate
    return false unless players.count.between?(4, 27)
    # return false if current_round == 1 && players.count.between?(5, 9)

    ordered_player_ids =
      if self.current_round.zero? # new tournament, just use newly created self.players
        players
      else # self.player_ranking returns ranked court array
        PlayerConfigs.player_court_distributor(player_ranking(self.current_round), players)
      end
    round = TournamentGenerator.new(self, ordered_player_ids)
    round.generate_round(current_round + 1)
  end

  def update_scores(score_payload, set_current_match)
    ##### Court 1
    # binding.pry
    court_1_match = tournament_sets.find_by(court: score_payload[:court], number: score_payload[:current_match])
    court_1_team1 = court_1_match.tournament_teams.find_by(number: 1)
    court_1_team2 = court_1_match.tournament_teams.find_by(number: 2)
    court_1_team1.update!(score: score_payload[:scores][:team1].to_i)
    court_1_team2.update!(score: score_payload[:scores][:team2].to_i)

    # ##### Court 2
    # if courts > 1
    #   court_2_match = tournament_sets.find_by(court: 2, number: score_payload[:current_match])
    #   court_2_team1 = court_2_match.tournament_teams.find_by(number: 1)
    #   court_2_team2 = court_2_match.tournament_teams.find_by(number: 2)
    #   court_2_team1.update!(score: score_payload[:scores][:team1].to_i)
    #   court_2_team2.update!(score: score_payload[:scores][:team2].to_i)
    # end


    # TODO: Court 3 and 4 for future
    ## we don't set current match if we're doing a utility drawer scores update
    if set_current_match
      if matches_per_round == score_payload[:current_match].to_i
        return
      else
        self.current_match = score_payload[:current_match].to_i + 1
      end
      save!
    end
  end

  def all_scores_entered?
    # This checks all scores (regardless of round). We're looking for tournament_teams, not work teams.
    # The result is a multi-dimensional array, we can flatten and then check for nils.
    scores = []
    tournament_sets.each do |set|
      scores << set.tournament_teams.where(work_team: nil).map(&:score)
    end
    all_scores = scores.flatten
    return false if all_scores.any?(nil)

    true
  end

  def process_round(round)
    return false if rounds_finalized.include?(round)

    create_user_scores(round)
    rounds_finalized = self.rounds_finalized # Grab current rounds finalized, push in current round just finalized (if first round, rounds_finalized will be empty to start)
    rounds_finalized << round
    associate_players
    generate unless rounds_finalized.count >= rounds

    completed = rounds_finalized.last == rounds ? true : false
    winner_id =
      if completed
        winner = self.player_ranking(self.rounds)[0].first
        winner[0]
      else
        0
      end

    update!(
      tournament_completed: completed,
      rounds_finalized: rounds_finalized,
      current_set: 1,
      current_round: current_round_calc(round, rounds),
      winner_id: winner_id
    )
    true
  end

  def create_user_scores(round)
    # This is for round finalization. tournament_team scores are set during scoring update, not team_user scores.
    # this method commits to the database
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

  def scoring(tournament_set)
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

  # deprecated (for mass update)
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
  end

  def self.sanitized_of_ghosts_players(player_ids)
    ghost_users_ids = User.where(is_ghost_player: true).collect(&:id)
    player_ids.map(&:to_i) - ghost_users_ids
  end

  def status_process_admin_views(currrent_timestamp)
    # remove stale views during display view fetch (this method should go away on convergence)
    # this covers when there's no admin view at all (all admin tabs / windows close)
    admin_views.each do |id, timestamp|
      admin_views.delete(id) if (currrent_timestamp.to_i - timestamp.to_i) >= 8 # going generous on 8 seconds
      save
    end
  end

  def process_admin_view(view)
    skip_some_callbacks = true
    # view = current admin page being examined
    # admin_view_current = current admin view id stored on tournament
    # admin_views = existing admin views (with timestamps) stored as hashes on tournament
    ## arguments: view[:id] view[:timestamp]
    #############################################################################################################################################################
    # - Delete view if older than x seconds, a refresh cause view to go stale and be deleted, pushing new admin_view_current
    # - Closing a browser would force new view id, causing old to go stale and be removed
    ### Scenarios for view to be admin_view_current:
    # - On new tournament creation, admin_view_current is blank, first view created wins
    # - f existing admin_current_view window closes, it would then become stale and transfer admin_current_view status to other open view

    # Remove stale views
    admin_views.each do |id, timestamp| # remove stale views
      admin_views.delete(id) if timestamp.to_i < (view[:timestamp].to_i - 4)
    end

    # Scan all views and clear admin_view_current if admin_view_current not in view set
    if !admin_views.keys.include?(admin_view_current.to_s)
      self.admin_view_current = nil
    end

    # If no current views, by default current view becomes master
    self.admin_view_current = view[:id] if self.admin_view_current.blank?

    # Confirm set current view to master if no other views
    self.admin_view_current = view[:id] if admin_views.count == 1

    # Update timestamp of existing view and save record
    admin_views[view[:id].to_s] = view[:timestamp].to_s
    save
  end

  def pre_match_time_formatted
    if pre_match_time >= 60
      "#{pre_match_time / 60} minutes"
    else
      "#{pre_match_time} seconds"
    end
  end

  def associate_players
    self.users = []
    players.each do |player|
      self.users << User.find(player)
    end
  end

  def calculate_total_tournament_time
    return unless tournament_sets.count.positive?
    return if match_time.blank? || matches_per_round.blank? || pre_match_time.blank? || rounds.blank?

    self.total_tournament_time = ((((match_time * matches_per_round) + ((matches_per_round - 1) * pre_match_time)) * rounds) / 60.0).round
  end

  def current_round_calc(current_round, total_rounds)
    if current_round.to_i == total_rounds.to_i
      current_round.to_i
    elsif total_rounds.to_i > current_round.to_i
      current_round.to_i + 1
    end
  end

  def total_match_time
    match_time + pre_match_time
  end
  # rubocop:enable Lint/NumberConversion
end
