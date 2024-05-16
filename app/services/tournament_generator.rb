# tournament generation
class TournamentGenerator
  attr_accessor :tournament, :players

  def initialize(tournament, players)
    # TODO: this should all be one database hit (save at end at some point)
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

    if @player_ids.count == 5
      create_court(tournament, round, 1, PlayerConfigs.p5, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 1, matches_per_round: 5, rounds: 1, configuration: 'p5')
    end

    if @player_ids.count == 6
      create_court(tournament, round, 1, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 1, matches_per_round: 10, rounds: 1, configuration: 'p6')
    end

    if @player_ids.count == 7
      create_court(tournament, round, 1, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 1, matches_per_round: 7, rounds: 1, configuration: 'p7')
    end

    if @player_ids.count == 8
      create_court(tournament, round, 1, PlayerConfigs.p8, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 2, courts: 1, matches_per_round: 8, rounds: 1, configuration: 'p8')
    end

    if @player_ids.count == 9
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 1, matches_per_round: 9, rounds: 1, configuration: 'p9')
    end

    if @player_ids.count == 10
      create_court(tournament, round, 1, PlayerConfigs.p10[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p10[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 2, matches_per_round: 10, rounds: 1, configuration: 'p10')
    end

    if @player_ids.count == 11
      create_court(tournament, round, 1, PlayerConfigs.p11[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p11[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 2, matches_per_round: 11, rounds: 1, configuration: 'p11')
    end

    if @player_ids.count == 12
      create_court(tournament, round, 1, PlayerConfigs.p12[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p12[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 2, matches_per_round: 11, rounds: 1, configuration: 'p12')
    end

    if @player_ids.count == 13
      create_court(tournament, round, 1, PlayerConfigs.p13[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p13[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 2, matches_per_round: 13, rounds: 1, configuration: 'p13')
    end

    if @player_ids.count == 14
      create_court(tournament, round, 1, PlayerConfigs.p14[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p14[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 2, courts: 2, matches_per_round: 14, rounds: 1, configuration: 'p14')
    end

    if @player_ids.count == 15
      create_court(tournament, round, 1, PlayerConfigs.p15[0], PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p15[1], PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 2, matches_per_round: 10, rounds: 1, configuration: 'p15')
    end
    
    #######################
    #######################
    #######################

    if @player_ids.count.between?(16, 17) # 2 courts of 9
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 2, matches_per_round: 12, rounds: 2, configuration: 'p9')
    end

    if @player_ids.count.between?(18, 21) # 3 courts of 7 | Top 1 pick from each, then smush the rest
      create_court(tournament, round, 1, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p7, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 1, courts: 3, matches_per_round: 7, rounds: 3, configuration: 'p7')
    end

    if @player_ids.count.between?(22, 24) # 4 courts of 6 | pair down courts
      create_court(tournament, round, 1, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 4, PlayerConfigs.p6, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 0, courts: 4, matches_per_round: 10, rounds: 3, configuration: 'p6')
    end

    if @player_ids.count.between?(25, 27) # 3 courts of 9 | top 3 each court for gold
      create_court(tournament, round, 1, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 2, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      create_court(tournament, round, 3, PlayerConfigs.p9, PlayerConfigs.new_round(@pids_hash))
      tournament.update(work_group: 3, courts: 3, matches_per_round: 12, rounds: 2, configuration: 'p9')
    end

    currently_configured = tournament.rounds_configured
    currently_configured << round.to_i
    tournament.update!(rounds_configured: currently_configured, total_tournament_time: calculate_total_tournament_time) if tournament.tournament_sets.count.positive?
  end

  def set_default_courts(courts_count)
    if courts_count == 1
      
    elsif courts_count == 2
    end
  end

  def calculate_total_tournament_time
    if tournament.tournament_sets.count.positive?
      ((((tournament.match_time * tournament.matches_per_round) + ((tournament.matches_per_round - 1) * tournament.pre_match_time)) * tournament.rounds) / 60.0).round(1)
    else
      0
    end
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
    team1 = TournamentTeam.create!(number: 1, tournament_id: tournament.id, court: court, round: round)
    team2 = TournamentTeam.create!(number: 2, tournament_id: tournament.id, court: court, round: round)
    # binding.pry
    config[0].each do |config_player_number|
      # binding.pry
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
