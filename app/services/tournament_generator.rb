# tournament generation
class TournamentGenerator
  attr_accessor :tournament, :players

  def initialize(tournament, players_per_team)
    @players_per_team = players_per_team
    @tournament = tournament
  end

  def generate_tournament
    players_count = @players_per_team.count
    associate_tournament_players(@tournament, players_query)

    if players_count == 13
      (0..6).each_with_index do |match, index|
        config = PlayerConfigurations.p7
        round = 1
        court = 1
        number = index + 1
        ghost_player = config[0][2] || 0
        create_match(tournament, number, round, court, config[match], players_query, ghost_player)
      end
      binding.pry 

      # collection should be associatd players for court 2
      (7..12).each_with_index do |match, index|
        round = 1
        court = 2
        ghost_player = 1
        create_match(tournament, number, round, court, config[match], players_query, ghost_player)
      end

    end

    tournament.update!(configured: true) if tournament.matches.count.positive?
  end

  def associate_tournament_players(tournament, players_query)
    players_query.each do |player|
      tournament.users << player
    end
  end

  def players_query
    # TODO: validation
    User.where(id: @players_per_team)
  end

  def create_match(tournament, number, round, court, config, players_query, ghost_player_id)
    match = Match.create(
      tournament_id: tournament.id,
      number: number,
      court: court,
      round: round,
      ghost_player_id: ghost_player_id
    )
    team1 = Team.create(number: 1, tournament_id: tournament.id)
    team2 = Team.create(number: 2, tournament_id: tournament.id)
    work_team = Team.create(number: 3, tournament_id: tournament.id, work_team?: true)

    config[0].each do |tp|
      team1.users << User.find(players_query[tp.to_i].id)
    end
    config[1].each do |tp|
      team2.users << User.find(players_query[tp.to_i].id)
    end
    config[2].each do |tp|
      work_team.users << User.find(players_query[tp.to_i].id)
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
  
  # def create_tournament #(players_per_team, total_matches)
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
  #   player_combinations = [*1...((@players_per_team * 2) + 1)].combination(2).to_a
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

  # def create_matches #(players_per_team, total_matches=1)
  #   base_team_array = [*1...((@players_per_team * 2) + 1)]
  #   total_players = @players_per_team * 2
  #   team_combinations = base_team_array.combination(@players_per_team)
  #   total_combinations = team_combinations.count
  #   all_match_configurations = []
  #   team_combinations.each do |team1|
  #     team2 = base_team_array - team1
  #     all_match_configurations << [team1, team2]
  #   end
  #   all_match_configurations
  # end

    # def create_array(players_per_team, matches)
  #   base_array = [*1...((players_per_team * 2) + 1)]
  #   matrix = []
  #   (0..(matches - 1)).each do |match|
  #     team1 = random_array(players_per_team, players_per_team * 2)
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
