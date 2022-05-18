# frozen_string_literal: true

# == Schema Information
#
# Table name: tournaments
#
#  id                :bigint           not null, primary key
#  address1          :string
#  address2          :string
#  break_time        :integer
#  city              :string
#  court_1_name      :string
#  court_2_name      :string
#  court_3_name      :string
#  court_4_name      :string
#  court_5_name      :string
#  court_6_name      :string
#  court_names       :string           default([]), is an Array
#  courts            :integer
#  current_set       :integer          default(1)
#  date              :datetime
#  name              :string
#  players           :integer          default([]), is an Array
#  rounds            :integer
#  rounds_configured :integer          default([]), is an Array
#  rounds_finalized  :integer          default([]), is an Array
#  state             :string
#  team_size         :integer
#  timer_status      :string           default("reset")
#  tournament_time   :integer
#  work_group        :integer
#  zip               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :user_scores

  def generate_tournament
    return false unless players.count.between?(8, 14)

    tournament_generator = TournamentGenerator.new(self, players)
    tournament_generator.generate_round(1)
    true
  end

  def create_user_scores(round)
    matches.where(round: round).each do |match|
      score = scoring(match)
      match.teams.each do |team|
        next if team.work_team

        team.users.each do |user|
          user.user_scores.create(
            tournament_id: match.tournament.id,
            match_id: match.id, team_id: team.id,
            court: match.court, round: match.round,
            score: team.number == 1 ? score[:team1][:score] : score[:team2][:score],
            win: team.number == 1 ? score[:team1][:win] : score[:team2][:win],
            loss: team.number == 1 ? score[:team1][:loss] : score[:team2][:loss]
          )
        end
      end
    end
  end

  def court_names_pretty
    court_names == [] ? '' : court_names.join(', ')
  end

  def player_ranking(round)
    court_1_scores = []
    court_2_scores = []
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
    end

    court_1_sorted = court_1_scores.sort_by { |a| [-a[3], -a[2]] }
    court_2_sorted = court_2_scores.sort_by { |a| [-a[3], -a[2]] }

    [court_1_sorted, court_2_sorted]
  end

  def round_two_courts_generate(round_1_sorted)
    team_counts = player_count_calc(round_1_sorted)
    all_player_ids = players.map(&:to_i)
    gold_team_ids = (round_1_sorted[0].first(team_counts[0]) + round_1_sorted[1].first(team_counts[1])).collect(&:first)
    silver_team_ids = all_player_ids - gold_team_ids
    ordered_player_ids = gold_team_ids + silver_team_ids

    round_two_generation = TournamentGenerator.new(self, Tournament.sanitized_of_ghosts_players(ordered_player_ids))
    round_two_generation.generate_round(2)
  end

  def player_count_calc(player_count)
    first_team_count = player_count[0].count.even? ? player_count[0].count / 2 : (player_count[0].count.to_f / 2).ceil
    second_team_count = player_count[1].count.even? ? player_count[1].count / 2 : (player_count[1].count.to_f / 2).ceil

    [first_team_count, second_team_count]
  end

  def scoring(match)
    # TODO: handle nil scores
    team_1_score = match.teams.find_by(number: 1).score ||= 0
    team_2_score = match.teams.find_by(number: 2).score ||= 0
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
        no_score_team = Team.find(score_data[team_number][:team_id])
        current_set = no_score_team.matches.first.number
        # if we find a blank score, we update tournament.current_set and mark found_current
        # which will break out of loop on next pass
        update(current_set: current_set)
        found_current = true
      end
    end
    # if we find no empty scores, set current_set so no rows are highlighted
    update(current_set: 99) if found_current == false
  end

  def self.sanitized_of_ghosts_players(player_ids)
    ghost_users_ids = User.where(is_ghost_player: true).collect(&:id)
    player_ids.map(&:to_i) - ghost_users_ids
  end
end
