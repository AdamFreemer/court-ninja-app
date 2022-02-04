# frozen_string_literal: true

class TournamentGenerator
  attr_accessor :players, :courts

  def initialize(players, courts=1)
    @players = players
    @courts = courts
  end

  def generate_tournament
    if players.count == 7
      create_tournament(7)
    elsif players.count == 8
      # stuff
    elsif players.count == 9
      # stuff
    end
  end

  def create_tournament
    binding.pry
    players_count = players.count
    # make generic with attribute for players
    players_query
    court = 1
    tournament = Tournament.create
    if players_count == 7
      (0..(players_count - 1)).each do |match|
        create_match(match, tournament.id, court, t7_config[match], players_query)
      end
    end
  end

  def create_match(number, tournament, court=1, config, players_query)
    match = Match.create(
      tournament_id: tournament,
      court: court, number: number
    )
    binding.pry
    team_1 = Team.create
    team_2 = Team.create

    config[0].each do |tp|
      team_1.team_users.create(user_id: players_query[tp.to_i].id)
    end

    config[1].each do |tp|
      team_2.team_users.create(user_id: players_query[tp.to_i].id)
    end


  end

  def players_query
    # TODO: validation
    User.where(id: players)
  end

  def t7_config
    [
      [[0, 1, 2], [3, 4, 5]],
      [[0, 3, 6], [1, 2, 4]],
      [[1, 5, 6], [0, 2, 3]],
      [[1, 3, 4], [2, 5, 6]],
      [[0, 4, 6], [2, 3, 5]],
      [[0, 1, 5], [2, 4, 6]],
      [[0, 4, 5], [1, 3, 6]]
    ]
  end
end
