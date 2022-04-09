# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :user_scores

  def finalize_scores
    matches.each do |match|
      score = scoring(match)
      # binding.pry
      team_1 = match.teams.find_by(number: 1)
      team_2 = match.teams.find_by(number: 2)
      match.teams.each do |team|
        next if team.work_team?

        team.users.each do |user|
          puts "######### scores"
          puts score
          # binding.pry
          user.user_scores.create(
            match_id: match.id,
            team_id: team_1.id,
            tournament_id: match.tournament.id,
            score: team.number == 1 ? score[:team_1][:score] : score[:team_2][:score],
            win_loss: team.number == 1 ? score[:team_1][:result] : score[:team_1][:result]
          )
        end
      end
    end
  end

  def scoring(match)
    team_1_score = match.teams.find_by(number: 1).score
    team_2_score = match.teams.find_by(number: 2).score
    score_delta = (team_1_score - team_2_score).abs

    if team_1_score > team_2_score
      { 
        team_1: { result: 'win', score: score_delta },
        team_2: { result: 'loss', score: -(score_delta) }
      }
    else
      { 
        team_1: { result: 'loss', score: -(score_delta) },
        team_2: { result: 'win', score: score_delta }
      }
    end
  end
end
