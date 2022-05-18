# tournament generation
class TournamentGenerator
  attr_accessor :tournament, :players

  def initialize(tournament, players)
    @players = players
    @tournament = tournament
  end

  def generate_round(round)
    # create_court(tournament, round, court, # players on court, player config, court config)
    if @players.count.between?(8, 9)
      associate_tournament_players(@tournament, @players, round)
      create_court(tournament, round, 1, PlayerConfigurations.p9, players_count_8_9)
      tournament.update(work_group: 3, courts: 1, rounds: 1)
    end

    if @players.count == 10
      associate_tournament_players(@tournament, @players, round)
      create_court(tournament, round, 1, PlayerConfigurations.p5, players_count_10)
      create_court(tournament, round, 2, PlayerConfigurations.p5, players_count_10)
      tournament.update(work_group: 1, courts: 2, rounds: 2)
    end

    if @players.count.between?(12, 14)
      associate_tournament_players(@tournament, @players, round)
      create_court(tournament, round, 1, PlayerConfigurations.p7, players_count_12_14)
      create_court(tournament, round, 2, PlayerConfigurations.p7, players_count_12_14)
      tournament.update(work_group: 1, courts: 2, rounds: 2)
    end

    currently_configured = tournament.rounds_configured
    currently_configured << round.to_i
    tournament.update!(rounds_configured: currently_configured) if tournament.matches.count.positive?
  end

  ## Court configurations per player count
  def players_count_8_9
    player_ids = @players.map(&:to_i)
    ghost_ids = User.where(is_ghost_player: true).collect(&:id)

    case players.count
    when 8
      { court1: player_ids.first(8) + [ghost_ids.first], court2: [] }
    when 9
      { court1: player_ids.first(9) }
    end
  end

  def players_count_10
    player_ids = @players.map(&:to_i)
    ghost_ids = User.where(is_ghost_player: true).collect(&:id)

    { court1: player_ids.first(5), court2: player_ids.last(5) }
  end

  # def players_count_11
  #   player_ids = @players.map(&:to_i)

  #   { court1: player_ids.first(6), court2: player_ids.last(5) + [ghost_ids.first] }
  # end

  def players_count_12_14
    player_ids = @players.map(&:to_i)
    ghost_ids = User.where(is_ghost_player: true).collect(&:id)

    case players.count
    when 12
      { court1: player_ids.first(6) + ghost_ids.first(1), court2: player_ids.last(6) + ghost_ids.last(1) }
    when 13
      { court1: player_ids.first(7), court2: player_ids.last(6) + ghost_ids.last(1) }
    when 14
      { court1: player_ids.first(7), court2: player_ids.last(7) }
    end
  end

  def associate_tournament_players(tournament, players, round)
    return if round != 1

    players.each do |player|
      tournament.users << User.find(player)
    end
  end

  def create_court(tournament, round, court, configuration, players_count)
    round_count = configuration.length - 1
    (0..round_count).each do |match|
      number = match + 1
      create_match(
        tournament,
        number,
        round,
        court,
        configuration[match],
        court == 1 ? players_count[:court1] : players_count[:court2]
      )
    end
  end

  def create_match(tournament, number, round, court, config, team_ids)
    match = Match.create(
      tournament_id: tournament.id,
      number: number,
      court: court,
      round: round
    )
    team1 = Team.create(number: 1, tournament_id: tournament.id)
    team2 = Team.create(number: 2, tournament_id: tournament.id)

    config[0].each do |config_player_number|
      team1.users << User.find(team_ids[config_player_number - 1])
    end
    config[1].each do |config_player_number|
      puts "====================== #{team_ids[config_player_number - 1]}"
      team2.users << User.find(team_ids[config_player_number - 1])
    end

    if config.length == 3
      # We only create work team if 3rd element in config array (work team player ids) exists
      work_team = Team.create(number: 3, tournament_id: tournament.id, work_team: true)
      config[2].each do |config_player_number|
        work_team.users << User.find(team_ids[config_player_number - 1])
      end
    end

    match.teams << team1
    match.teams << team2
    match.teams << work_team if config.length == 3
  end
end
