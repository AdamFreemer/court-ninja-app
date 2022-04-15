# tournament generation
class TournamentGenerator
  attr_accessor :tournament, :players

  def initialize(tournament, players)
    @players = players
    @tournament = tournament
  end

  def generate_round(t_round)
    players_count = @players.count

    if players_count == 13
      players = players_combined(1) # where we add in ghost player(s)
      associate_tournament_players(@tournament, players)

      (0..6).each do |match|
        config = PlayerConfigurations.p7
        number = match + 1
        round = t_round
        court = 1
        create_match(
          tournament,
          number,
          round,
          court,
          config[match],
          players.first(7)
        )
      end

      (0..6).each do |match|
        config = PlayerConfigurations.p7
        number = match + 1
        round = 1
        court = 2
        create_match(
          tournament,
          number,
          round,
          court,
          config[match],
          players.last(7)
        )
      end
    end

    tournament.update!(configured: true) if tournament.matches.count.positive?
  end

  def associate_tournament_players(tournament, players)
    players.each do |player|
      tournament.users << User.find(player)
    end
  end

  def players_combined(ghost_players)
    if ghost_players.zero?
      @players
    elsif ghost_players == 1
      @players << User.find_by(email: '_ghost_player1@mail.com').id
    else
      @players
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
    work_team = Team.create(number: 3, tournament_id: tournament.id, work_team?: true)

    config[0].each do |config_player_number|
      team1.users << User.find(team_ids[config_player_number - 1])
    end
    config[1].each do |config_player_number|
      team2.users << User.find(team_ids[config_player_number - 1])
    end
    config[2].each do |config_player_number|
      work_team.users << User.find(team_ids[config_player_number - 1])
    end

    match.teams << team1
    match.teams << team2
    match.teams << work_team
  end

  # def match_generator(players_count)
  #   # combo = 0
  #   all_combinations = if players_count.even?
  #                        base_array = [*1...(players_count + 1)]
  #                        matches = [base_array]
  #                        [*1...(players_count + 1)].combination(players_count / 2).to_a
  #                      else
  #                        base_array = [*1...(players_count + 2)]
  #                        matches = []
  #                        [*1...(players_count + 2)].combination((players_count + 1) / 2).to_a
  #                      end
  #   all_combinations.each do |set| # List of all unique match possibilities
  #     puts "== matches: #{matches.count}"
  #     all_combinations.each do |compare_set| # Compare each to all possibilities including self
  #       set_combined = set + compare_set
  #       # combo = combo + 1
  #       # puts "== #{combo} | #{set_combined}"
  #       if set.sum + compare_set.sum == base_array.sum && set_combined.length == set_combined.uniq.length
  #         next if matches.include?(set_combined) # Next if matches include current match configuration

  #         if players_count.even? # Array is same length as players_count
  #           next if matches.include?((set_combined).rotate(base_array.count / 2)) # Next if teams are same but swapped
  #         else
  #           # We add 1 to array length in odd players_count case to run same "even" algorithm.
  #           # Rows ending in an element with players_count will have unique other elements
  #           # We skip adding a combination unless the last digit is ending in an element with players_count
  #           next if set_combined.last != players_count + 1

  #           set_combined.pop
  #         end
  #         next if matches.count > players_count * 2

  #         matches << set_combined
  #       end
  #     end
  #   end
  #   matches
  # end
  
  # def create_tournament #(players, total_matches)
  #   matches = create_matches
  #   player_combinations = create_player_combination_totals
  #   matches.each do |match|
  #     player_combinations.each do |combination|
  #       binding.pry
  #       played_each_other = (match.first.include?(combination[:combination].first) && match.last.include?(combination[:combination].last)) ||
  #                           (match.first.include?(combination[:combination].last) && match.last.include?(combination[:combination].first))
  #       played_together = (match.first.include?(combination[:combination].first) && match.first.include?(combination[:combination].last)) ||
  #                         (match.last.include?(combination[:combination].first) && match.last.include?(combination[:combination].last))

  #       if played_each_other
  #         combination[:played_each_other] = combination[:played_each_other] + 1
  #       end

  #       if played_together
  #         combination[:played_together] = combination[:played_together] + 1
  #       end
  #     end
  #   end
  #   puts matches.to_a
  #   puts player_combinations
  #   # TODO: analyze player_combination_totals
  # end

  # def create_player_combination_totals
  #   player_combinations = [*1...((@players * 2) + 1)].combination(2).to_a
  #   # Data structure to keep count of players // {1=>[0, 0], 2=>[0, 0]}
  #   # key/value pair (hash) of arrays, hash key is player number, value is 2 element array
  #   # first element in array is played_together for this combination, 2nd element = played_each_other
  #   player_combination_totals = []
  #   player_combinations.each do |combination|
  #     player_combination_totals << { combination: combination, played_each_other: 0, played_together: 0 }
  #     # player_combination_totals[combination] = [0, 0]
  #   end
  #   player_combination_totals
  # end

  # def create_matches #(players, total_matches=1)
  #   base_team_array = [*1...((@players * 2) + 1)]
  #   total_players = @players * 2
  #   team_combinations = base_team_array.combination(@players)
  #   total_combinations = team_combinations.count
  #   all_match_configurations = []
  #   team_combinations.each do |team1|
  #     team2 = base_team_array - team1
  #     all_match_configurations << [team1, team2]
  #   end
  #   all_match_configurations
  # end

    # def create_array(players, matches)
  #   base_array = [*1...((players * 2) + 1)]
  #   matrix = []
  #   (0..(matches - 1)).each do |match|
  #     team1 = random_array(players, players * 2)
  #     team2 = base_array - team1
  #     matrix << [team1.sort, team2.sort] #.sum
  #   end
  #   matrix
  # end


  # def random_array(n, max)
  #   # n = element, max = n
  #   randoms = Set.new
  #   loop do
  #     randoms << rand(max) + 1
  #     return randoms.to_a if randoms.size >= n
  #   end
  # end

end
