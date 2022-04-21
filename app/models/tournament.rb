# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches
  has_many :tournament_users
  has_many :users, through: :tournament_users
  has_many :user_scores

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

  def player_ranking(round)
    court_1_scores = []
    court_2_scores = []
    players = User.where(id: users)
    players.each do |player|
      next if player.is_ghost_player == true

      score = player.user_scores.where(tournament_id: id, round: 1).sum(:score)
      wins = player.user_scores.where(tournament_id: id, round: 1).sum(:win)
      court_1_scores << [player.id, player.name_abbreviated, score, wins] if player.user_scores.first.court == 1
      court_2_scores << [player.id, player.name_abbreviated, score, wins] if player.user_scores.first.court == 2
    end
    court_1_sorted = court_1_scores.sort_by { |a| [-a[3], -a[2]] }
    court_2_sorted = court_2_scores.sort_by { |a| [-a[3], -a[2]] }

    [court_1_sorted, court_2_sorted]
  end

  def round_two_courts_generate(round_1_sorted)
    # i'm pulling in all players, I think should be player_ranking (13) not all players
    all_player_ids = players.map(&:to_i)
    gold_team_ids = (round_1_sorted[0].first(4) + round_1_sorted[1].first(3)).collect(&:first)
    silver_team_ids = all_player_ids - gold_team_ids
    ordered_player_ids = gold_team_ids + silver_team_ids
    # feed in players to tournament generator combined "gold" team first
    round_two_generation = TournamentGenerator.new(self, Tournament.sanitized_of_ghosts_players(ordered_player_ids))
    round_two_generation.generate_round(2)
  end

  def results_generate(round_2_sorted)
    
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

  def self.sanitized_of_ghosts_players(player_ids)
    ghost_users_ids = User.where(is_ghost_player: true).collect(&:id)
    player_ids.map(&:to_i) - ghost_users_ids
  end
end
