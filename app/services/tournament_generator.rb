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

  def match_generator(players_count)
    # base_array = [*1...(players_count + 1)]
    # binding.pry
    combo = 0
    all_combinations = if players_count.even?
                         base_array = [*1...(players_count + 1)]
                         matches = [base_array]
                         [*1...(players_count + 1)].combination(players_count / 2).to_a
                       else
                         base_array = [*1...(players_count + 2)]
                         matches = []
                         [*1...(players_count + 2)].combination((players_count + 1) / 2).to_a
                       end
    all_combinations.each do |set| # List of all unique match possibilities
      all_combinations.each do |compare_set| # Compare each to all possibilities including self
        set_combined = set + compare_set
        combo = combo + 1
        puts "== #{combo} | #{set_combined}"
        if set.sum + compare_set.sum == base_array.sum && set_combined.length == set_combined.uniq.length
          next if matches.include?(set_combined) # Next if matches include current match configuration

          if players_count.even? # Array is same length as players_count
            next if matches.include?((set_combined).rotate(base_array.count / 2)) # Next if teams are same but swapped
          else
            # We add 1 to array length in odd players_count case to run same "even" algorithm.
            # Rows ending in an element with players_count will have unique other elements
            # We skip adding a combination unless the last digit is ending in an element with players_count
            next if set_combined.last != players_count + 1

            set_combined.pop
          end
          next if matches.count > players_count * 2

          matches << set_combined
        end
      end
    end
    matches
  end
end
