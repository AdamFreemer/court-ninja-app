# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :user_scores

  def finalize_scores
    # This is destructive / additive
    matches.each do |match|
      score = scoring(match)
      team_1 = match.teams.find_by(number: 1)
      team_2 = match.teams.find_by(number: 2)
      match.teams.each do |team|
        next if team.work_team?

        team.users.each do |user|
          user.user_scores.create(
            match_id: match.id,
            team_id: team.id,
            court: match.court,
            round: match.round,
            tournament_id: match.tournament.id,
            score: team.number == 1 ? score[:team1][:score] : score[:team2][:score],
            win_loss: team.number == 1 ? score[:team1][:result] : score[:team2][:result]
          )
        end
      end
    end
  end

  def player_ranking_round_1
    court_1_scores = []
    court_2_scores = []
    players = User.where(id: users)
    players.each do |player|
      next if player.is_ghost_player?

      score = player.user_scores.where(tournament_id: id, round: 1).sum(:score)
      court_1_scores << [player.id, player.first_name, score] if player.user_scores.first.court == 1
      court_2_scores << [player.id, player.first_name, score] if player.user_scores.first.court == 2
    end

    court_1_sorted = court_1_scores.sort_by{ |a| a.last }.reverse
    court_2_sorted = court_2_scores.sort_by{ |a| a.last }.reverse

    [court_1_sorted, court_2_sorted]
  end

  def round_two_courts_generate(round_1_court_1_sorted, round_1_court_2_sorted)
    binding.pry
    [court_1_sorted.first(4), court_2_sorted.first(3)]
  end

  def scoring(match)
    team_1_score = match.teams.find_by(number: 1).score
    team_2_score = match.teams.find_by(number: 2).score
    score_delta = (team_1_score - team_2_score).abs

    if team_1_score > team_2_score
      {
        team1: { result: 'win', score: score_delta },
        team2: { result: 'loss', score: -(score_delta) }
      }
    else
      {
        team1: { result: 'loss', score: -(score_delta) },
        team2: { result: 'win', score: score_delta }
      }
    end
  end
end
