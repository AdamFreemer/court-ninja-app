# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :teams
  has_many :matches

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :user_scores

  def finalize_scores
    matches.each do |match|
      binding.pry
      team_1 = match.teams.find_by(number: 1)
      team_2 = match.teams.find_by(number: 2)

      team_1.users.each do |user|
        user.user_scores.create(
          match_id: match.id,
          team_id: team_1.id,
          tournament_id: match.tournament.id,
          score: team_1.score.to_i > team_2.score.to_i,
          win_loss: 'win'
        )
      end

      if team_1.score.to_i > team_2.score.to_i

      
      end



    end
  end

  def team_scoring(team)
    

  end


end
