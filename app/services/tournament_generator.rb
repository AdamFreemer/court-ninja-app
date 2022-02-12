# frozen_string_literal: true

class TournamentGenerator
  attr_accessor :players, :courts, :tournament

  def initialize(players, courts=1, tournament)
    @players = players
    @courts = courts
    @tournament = tournament
  end

  def generate_tournament
    players_count = players.count
    court = 1
    associate_tournament_players(tournament, players_query)

    ## player count 7
    if players_count == 7
      (0..6).each do |match|
        create_match(match, tournament, court, t7_config[match], players_query)
      end
    end

    tournament.update!(configured: true) if tournament.matches.count.positive?
  end

  def create_match(number, tournament, court=1, config, players_query)
    match = Match.create(
      tournament_id: tournament.id,
      court: court, number: number
    )
    team1 = Team.create(number: 1, score: nil, tournament_id: tournament.id)
    team2 = Team.create(number: 2, score: nil, tournament_id: tournament.id)
    match.teams << team1
    match.teams << team2

    config[0].each do |tp|
      team1.users << User.find(players_query[tp.to_i].id)
    end
    config[1].each do |tp|
      team2.users << User.find(players_query[tp.to_i].id)
    end
  end

  def players_query
    # TODO: validation
    User.where(id: players)
  end

  def associate_tournament_players(tournament, players_query)
    players_query.each do |player|
      tournament.users << player
    end
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
