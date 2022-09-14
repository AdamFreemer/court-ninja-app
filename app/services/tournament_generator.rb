# tournament generation
class TournamentGenerator
  attr_accessor :tournament, :players

  def initialize(tournament, players)
    # when creating new tournament, we're shuffling player ids for randomness, subsequent rounds we're not
    ghost_ids = User.where(is_ghost_player: true).collect(&:id)
    @tournament = tournament
    @player_ids = players
    @pids_hash = { ids: player_order(tournament, players), ghosts: ghost_ids }
  end

  def generate_round(round)
    # player_ids from initialize do not have ghost_ids included yet
    # create_court(tournament, round, court, # players on court, player config, court config)
    # 1 create court for each court per round (15 player has 3 courts of 5 i.e. 3 create_court's)

    if @player_ids.count == 6
      create_court(tournament, round, 1, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 1, rounds: 1, configuration: "p6")
    end

    if @player_ids.count == 7
      create_court(tournament, round, 1, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 1, rounds: 1, configuration: "p7")
    end
    
    if @player_ids.count.between?(8, 9)
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 1, rounds: 1, configuration: "p9")
    end

    if @player_ids.count == 10
      create_court(tournament, round, 1, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 2, rounds: 2, configuration: "p5")
    end

    if @player_ids.count.between?(11, 12) # 2 courts of 6 | top 3 each court for gold round 2
      create_court(tournament, round, 1, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 2, rounds: 2, configuration: "p6")
    end

    if @player_ids.count.between?(13, 14) # 2 courts of 7 | Review
      create_court(tournament, round, 1, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 2, rounds: 2, configuration: "p7")
    end

    ## Below 14 is coach / team level role / package

    if @player_ids.count == 15 # 3 courts of 5 | Top 1 pick from each, then smush the rest
      create_court(tournament, round, 1, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 3, rounds: 3, configuration: "p5")
    end   

    if @player_ids.count.between?(16, 17) # 2 courts of 9
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 2, rounds: 2, configuration: "p9")
    end

    if @player_ids.count.between?(18, 21) # 3 courts of 7 | Top 1 pick from each, then smush the rest
      create_court(tournament, round, 1, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 3, rounds: 3, configuration: "p7")
    end

    if @player_ids.count.between?(22, 24) # 4 courts of 6 | pair down courts
      create_court(tournament, round, 1, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 4, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 4, rounds: 3, configuration: "p6")
    end

    if @player_ids.count.between?(25, 27) # 3 courts of 9 | top 3 each court for gold
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 3, rounds: 2, configuration: "p9")
    end

    currently_configured = tournament.rounds_configured
    currently_configured << round.to_i
    tournament.update!(rounds_configured: currently_configured) if tournament.tournament_sets.count.positive?
  end

  def player_order(tournament, players) # shuffle if first round, otherwise no
    tournament.rounds_configured == [] ? players.shuffle : players
  end

  def associate_tournament_players(tournament, players, round)
    return if round != 1

    players.each do |player|
      tournament.users << User.find(player)
    end
  end

  def create_court(tournament, round, court, configuration, players_count)
    player_ids = if court == 1
                   players_count[:court1]
                 elsif court == 2
                   players_count[:court2]
                 elsif court == 3
                   players_count[:court3]
                 elsif court == 4
                   players_count[:court4]
                 elsif court == 5
                   players_count[:court5]
                 elsif court == 6
                   players_count[:court6]
                 end

    set_count = configuration.length - 1
    (0..set_count).each do |tournament_set|
      number = tournament_set + 1
      create_tournament_set(
        tournament,
        number,
        round,
        court,
        configuration[tournament_set],
        player_ids
      )
    end
  end

  def create_tournament_set(tournament, number, round, court, config, player_ids)
    tournament_set = TournamentSet.create(
      tournament_id: tournament.id,
      number: number,
      court: court,
      round: round
    )
    team1 = TournamentTeam.create(number: 1, tournament_id: tournament.id)
    team2 = TournamentTeam.create(number: 2, tournament_id: tournament.id)

    config[0].each do |config_player_number|
      team1.users << User.find(player_ids[config_player_number - 1])
    end
    config[1].each do |config_player_number|
      team2.users << User.find(player_ids[config_player_number - 1])
    end

    if config.length == 3
      # We only create work team if 3rd element in config array (work team player ids) exists
      work_team = TournamentTeam.create(number: 3, tournament_id: tournament.id, work_team: true)
      config[2].each do |config_player_number|
        work_team.users << User.find(player_ids[config_player_number - 1])
      end
    end

    tournament_set.tournament_teams << team1
    tournament_set.tournament_teams << team2
    tournament_set.tournament_teams << work_team if config.length == 3
  end
end
