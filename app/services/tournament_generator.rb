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

    ## rules engine will go here
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

  def even_count_match_generator(players_count)
    base_array = [*1...(players_count + 1)]
    all_combinations = base_array.combination(players_count / 2).to_a
    matches = [base_array]
    all_combinations.each do |set|
      all_combinations.each do |sub_set|
        set_combined = set + sub_set
        if set.sum + sub_set.sum == base_array.sum && set_combined.length == set_combined.uniq.length
          next if matches.include?(set_combined) || matches.include?((set_combined).rotate(base_array.count / 2))

          matches << (set + sub_set)
        end
      end
    end
    matches
  end
end
