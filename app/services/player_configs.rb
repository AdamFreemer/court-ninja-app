module PlayerConfigs
# tournament configurations
# These arrays are based off the bjerring tables: https://vbc.cyburi.com/resource/LinearRankingTournament.pdf
# For each row, 1st array is Team 1, 2nd array is Team 2. If there's a work (non-playing) Team, that is the 3rd array.

###### Notes
###### [side 1], [side 2], [byes]
###### Courts are grouped per each

def self.p4
  # 5 matches
  [
    [[1, 2], [3, 4], []],
    [[1, 3], [2, 4], []],
    [[1, 4], [2, 3], []]
  ]
end

def self.p5
    [
      [[1, 2], [3, 4], [5]],
      [[2, 5], [1, 3], [4]],
      [[3, 5], [1, 4], [2]],
      [[1, 5], [2, 4], [3]],
      [[2, 3], [4, 5], [1]]
    ]
  end

  def self.p6
    [
      [[1, 2, 3], [4, 5, 6], []],
      [[3, 5, 6], [1, 2, 4], []],
      [[1, 2, 5], [3, 4, 6], []],
      [[1, 2, 6], [3, 4, 5], []],
      [[2, 5, 6], [1, 3, 4], []],
      [[1, 3, 5], [2, 4, 6], []],
      [[2, 4, 5], [1, 3, 6], []],
      [[1, 4, 5], [2, 3, 6], []],
      [[1, 4, 6], [2, 3, 5], []],
      [[2, 3, 4], [1, 5, 6], []]
    ]
  end

  def self.p7
    [
      [[1, 2, 3], [4, 5, 6], [7]],
      [[1, 4, 7], [2, 3, 5], [6]],
      [[2, 6, 7], [1, 3, 4], [5]],
      [[2, 4, 5], [3, 6, 7], [1]],
      [[1, 5, 7], [3, 4, 6], [2]],
      [[1, 2, 6], [3, 5, 7], [4]],
      [[1, 5, 6], [2, 4, 7], [3]]
    ]
  end

  def self.p8
    [
      [[7, 4, 1], [8, 3, 6], [2, 5]],
      [[8, 1, 2], [5, 4, 7], [3, 6]],
      [[5, 2, 3], [6, 1, 8], [4, 7]],
      [[6, 3, 4], [7, 2, 5], [1, 8]],
      [[4, 8, 5], [1, 7, 3], [2, 6]],
      [[1, 5, 6], [2, 8, 4], [3, 7]],
      [[2, 6, 7], [3, 5, 1], [4, 8]],
      [[3, 7, 8], [4, 6, 2], [1, 5]]
    ]
  end

  def self.p8_2
    # TODO: /display_controller.js need to add 4 card code
    [
      [[8, 5, 1, 6], [2, 3, 4, 7], []],
      [[8, 6, 2, 7], [3, 4, 5, 1], []],
      [[8, 7, 3, 1], [4, 5, 6, 2], []],
      [[8, 1, 4, 2], [5, 6, 7, 3], []],
      [[8, 2, 5, 3], [6, 7, 1, 4], []],
      [[8, 3, 6, 4], [7, 1, 2, 5], []],
      [[8, 4, 7, 5], [1, 2, 3, 6], []]
    ]
  end

  def self.p9
    [
      [[3, 5, 6], [9, 1, 8], [2, 7, 4]],
      [[1, 6, 4], [7, 2, 9], [3, 8, 5]],
      [[2, 4, 5], [8, 3, 7], [1, 9, 6]],
      [[9, 3, 4], [1, 8, 7], [6, 2, 5]],
      [[7, 1, 5], [2, 9, 8], [4, 3, 6]],
      [[8, 2, 6], [3, 7, 9], [5, 1, 4]],
      [[4, 6, 7], [3, 1, 5], [2, 9, 8]],
      [[5, 4, 8], [1, 2, 6], [3, 7, 9]],
      [[6, 5, 9], [2, 3, 4], [1, 8, 7]]
    ]
  end

  def self.p10
    [
      [
        [[1, 5],  [7, 10], [2]],
        [[2, 1],  [8, 6],  [3]],
        [[3, 2],  [9, 7],  [4]],
        [[4, 3],  [10, 8], [5]],
        [[5, 4],  [6, 9],  [1]],
        [[7, 6],  [4, 8], [10]],
        [[8, 7],  [5, 9],  [6]],
        [[9, 8],  [1, 10], [7]],
        [[10, 9], [2, 6],  [8]],
        [[6, 10], [3, 7],  [9]]
      ],
      [
        [[6,  4], [9,  3], [ 8]],
        [[7,  5], [10, 4], [ 9]],
        [[8,  1], [6,  5], [10]],
        [[9,  2], [7,  1], [ 6]],
        [[10, 3], [8,  2], [ 7]],
        [[1,  9], [5,  3], [ 2]],
        [[2, 10], [1,  4], [ 3]],
        [[3,  6], [2,  5], [ 4]],
        [[4,  7], [3,  1], [ 5]],
        [[5,  8], [4,  2], [ 1]]
      ]
    ]
  end

  def self.p11
    [
      [
        [[6,  4], [7,  2],  [8, 3]],
        [[7,  5], [8,  3],  [9, 4]],
        [[8,  6], [9,  4],  [10, 5]],
        [[9,  7], [10, 5],  [11, 6]],
        [[10, 8], [11, 6],  [1, 7]],
        [[11, 9], [1,  7],  [2, 8]],
        [[1, 10], [2,  8],  [3, 9]],
        [[2, 11], [3,  9],  [4, 10]],
        [[3,  1], [4, 10],  [5, 11]],
        [[4,  2], [5, 11],  [6, 1]],
        [[5,  3], [6,  1],  [7, 2]]
      ],
      [
        [[11, 1], [9,  5], [10]],
        [[1,  2], [10, 6], [11]],
        [[2,  3], [11, 7], [1]],
        [[3,  4], [1,  8], [2]],
        [[4,  5], [2,  9], [3]],
        [[5,  6], [3, 10], [4]],
        [[6,  7], [4, 11], [5]],
        [[7,  8], [5,  1], [6]],
        [[8,  9], [6,  2], [7]],
        [[9, 10], [7,  3], [8]],
        [[10,11], [8,  4], [9]]
      ]
    ]
  end

  def self.p12
    [
      [
        [[2, 3, 9],   [7, 10, 1], []],
        [[3, 4, 10],  [8, 11, 2], []],
        [[4, 5, 11],  [9, 1, 3],  []],
        [[5, 6, 1],   [10, 2, 4], []],
        [[6, 7, 2],   [11, 3, 5], []],
        [[7, 8, 3],   [1, 4, 6],  []],
        [[8, 9, 4],   [2, 5, 7],  []],
        [[9, 10, 5],  [3, 6, 8],  []],
        [[10, 11, 6], [4, 7, 9],  []],
        [[11, 1, 7],  [5, 8, 10], []],
        [[1, 2, 8],   [6, 9, 11], []]
      ],
      [
        [[8, 5, 6],   [12, 4, 11], []],
        [[9, 6, 7],   [12, 5, 1],  []],
        [[10, 7, 8],  [12, 6, 2],  []],
        [[11, 8, 9],  [12, 7, 3],  []],
        [[1, 9, 10],  [12, 8, 4],  []],
        [[2, 10, 11], [12, 9, 5],  []],
        [[3, 11, 1],  [12, 10, 6], []],
        [[4, 1, 2],   [12, 11, 7], []],
        [[5, 2, 3],   [12, 1, 8],  []],
        [[6, 3, 4],   [12, 2, 9],  []],
        [[7, 4, 5],   [12, 3, 10], []]
      ]
    ]
  end

  def self.p13
    [
      [
        [[2, 11, 4],  [13, 5, 10], [1]],
        [[3, 12, 5],  [1, 6,  11], [2]],
        [[4, 13, 6],  [2, 7,  12], [3]],
        [[5, 1,  7],  [3, 8,  13], [4]],
        [[6, 2,  8],  [4, 9,   1], [5]],
        [[7, 3,  9],  [5, 10,  2], [6]],
        [[8, 4, 10],  [6, 11,  3], [7]],
        [[9, 5, 11],  [7, 12,  4], [8]],
        [[10, 6, 12], [8, 13,  5], [9]],
        [[11, 7, 13], [9,  1,  6], [10]],
        [[12, 8,  1], [10, 2,  7], [11]],
        [[13, 9,  2], [11, 3,  8], [12]],
        [[1, 10, 3],  [12, 4,  9], [13]]
      ],
      [
        [[6, 7,  8], [12, 3,  9], []],
        [[7, 8,  9], [13, 4, 10], []],
        [[8, 9, 10], [1,  5, 11], []],
        [[9, 10,11], [2,  6, 12], []],
        [[10,11,12], [3,  7, 13], []],
        [[11,12,13], [4,  8,  1], []],
        [[12,13, 1], [5,  9,  2], []],
        [[13,1,  2], [6, 10,  3], []],
        [[1, 2,  3], [7, 11,  4], []],
        [[2, 3,  4], [8, 12,  5], []],
        [[3, 4,  5], [9, 13,  6], []],
        [[4, 5,  6], [10, 1,  7], []],
        [[5, 6,  7], [11, 2,  8], []]
      ]
    ]
  end

  def self.p14
    [
      [
        [[8, 1, 12],  [13, 11, 7], [5]],
        [[9, 2, 13],  [14, 12, 8], [6]],
        [[10, 3, 14], [1, 13, 9],  [7]],
        [[11, 4, 1],  [2, 14, 10], [8]],
        [[12, 5, 2],  [3, 1, 11],  [9]],
        [[13, 6, 3],  [4, 2, 12], [10]],
        [[14, 7, 4],  [5, 3, 13], [11]],
        [[1, 8, 5],   [6, 4, 14], [12]],
        [[2, 9, 6],   [7, 5, 1],  [13]],
        [[3, 10, 7],  [8, 6, 2],  [14]],
        [[4, 11, 8],  [9, 7, 3],   [1]],
        [[5, 12, 9],  [10, 8, 4],  [2]],
        [[6, 13, 10], [11, 9, 5],  [3]],
        [[7, 14, 11], [12, 10, 6], [4]]
      ],
      [
        [[9, 14, 6],  [4, 3, 2], [10]],
        [[10, 1, 7],  [5, 4, 3], [11]],
        [[11, 2, 8],  [6, 5, 4], [12]],
        [[12, 3, 9],  [7, 6, 5], [13]],
        [[13, 4, 10], [8, 7, 6], [14]],
        [[14, 5, 11], [9, 8, 7], [1]],
        [[1, 6, 12],  [10, 9, 8], [2]],
        [[2, 7, 13],  [11, 10, 9], [3]],
        [[3, 8, 14],  [12, 11, 10], [4]],
        [[4, 9, 1],   [13, 12, 11], [5]],
        [[5, 10, 2],  [14, 13, 12], [6]],
        [[6, 11, 3],  [1, 14, 13], [7]],
        [[7, 12, 4],  [2, 1, 14], [8]],
        [[8, 13, 5],  [3, 2, 1], [9]]
      ]
    ]
  end

  def self.p15
    [
      [
        [[8, 7, 2],  [14, 6, 9],  [1, 12]],
        [[9, 8, 3],  [15, 7, 10], [13, 4]],
        [[10, 9, 4], [11, 8, 6],  [3, 14]],
        [[6, 10, 5], [12, 9, 7],  [15, 1]],
        [[7, 6, 1],  [13, 10, 8], [5, 11]],
        [[2, 3, 1],  [11, 5, 9],  [7, 15]],
        [[3, 4, 2],  [12, 1, 10], [7, 8]],
        [[4, 5, 3],  [13, 2, 6],  [9, 12]],
        [[5, 1, 4],  [14, 3, 7],  [9, 10]],
        [[1, 2, 5],  [15, 4, 8],  [6, 14]]
      ],
      [
        [[11, 4, 10], [13, 5, 15], [3]],
        [[12, 5, 6],  [14, 1, 11], [2]],
        [[13, 1, 7],  [15, 2, 12], [5]],
        [[14, 2, 8],  [11, 3, 13], [4]],
        [[15, 3, 9],  [12, 4, 14], [2]],
        [[12, 8, 10], [13, 14, 4], [6]],
        [[13, 9, 6],  [14, 15, 5], [11]],
        [[14, 10, 7], [15, 11, 1], [8]],
        [[15, 6, 8],  [11, 12, 2], [13]],
        [[11, 7, 9],  [12, 13, 3], [10]]
      ]
    ]
  end

  def self.player_court_distributor(round_sorted, players)
    # Ranking decision engine based on player count for each round.
    # Returned is a single array of player / user ids in descending performance order.
    # Tournament generator divides up on a first-in bases per court (i.e. first 5 players in array fill
    # first court of 15 player / 3 court tournament)
    case round_sorted.flatten(1).count
    # court count starts at 10 when multiple court / multiple rounds start
    when 10
      # Method: Top 3 court 1, top 2 court 2, followed by remaining
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(2)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 11
      # Method: Top 3 both courts, followed by remaining
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 12
      # Method: Top 3 both courts, followed by remaining
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 13
      # Method: Top 4 court 1, top 3 court 2, followed by remaining
      gold_ids = (round_sorted[0].first(4) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 14
      # Method: Top 4 court 1, top 3 court 2, followed by remaining
      gold_ids = (round_sorted[0].first(4) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 15
      # Method: Top 3 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first).collect(&:first)
      remaining_player_ids = (round_sorted[0].last(4) + round_sorted[1].last(4) + round_sorted[2].last(4)).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 16
      # Method: Top 5 court 1, top 4 court 2, followed by remaining
      gold_ids = (round_sorted[0].first(5) + round_sorted[1].first(4)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 17
      # Method: Top 5 court 1, top 4 court 2, followed by remaining
      gold_ids = (round_sorted[0].first(5) + round_sorted[1].first(4)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 18
      # Method: Top 3 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(6) + 
        round_sorted[1].last(6) + 
        round_sorted[2].last(6)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 19
      # Method: Top 3 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(6) + 
        round_sorted[1].last(5) + 
        round_sorted[2].last(5)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 20
      # Method: Top 3 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(6) + 
        round_sorted[1].last(6) + 
        round_sorted[2].last(5)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 21
      # Method: Top 3 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(6) + 
        round_sorted[1].last(6) + 
        round_sorted[2].last(6)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 22
      # Method: Top 4 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first + round_sorted[3].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(5) + 
        round_sorted[1].last(5) + 
        round_sorted[2].last(4) + 
        round_sorted[3].last(4)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids     
    when 23
      # Method: Top 4 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first + round_sorted[3].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(5) + 
        round_sorted[1].last(5) + 
        round_sorted[2].last(5) + 
        round_sorted[3].last(4)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids    
    when 24
      # Method: Top 4 court leaders, combine remaining in descending order
      top_court_ids = (round_sorted[0].first + round_sorted[1].first + round_sorted[2].first + round_sorted[3].first).collect(&:first)
      remaining_player_ids = (
        round_sorted[0].last(5) + 
        round_sorted[1].last(5) + 
        round_sorted[2].last(5) + 
        round_sorted[3].last(5)
      ).sort_by { |a| [-a[3], -a[2]] }.collect(&:first)
      top_court_ids + remaining_player_ids
    when 25
      # Method: Top 4 court leaders, combine remaining in descending order
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3) + round_sorted[2].first(3)).collect(&:first).sort
      silver_ids = (
        (round_sorted[0].last(6) - round_sorted[0].last(3)) +
        (round_sorted[1].last(5) - round_sorted[0].last(3)) +
        (round_sorted[2].last(5) - round_sorted[0].last(3))
      ).collect(&:first).sort
      bronze_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 26
      # Method: Top 4 court leaders, combine remaining in descending order
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3) + round_sorted[2].first(3)).collect(&:first).sort
      silver_ids = (
        (round_sorted[0].last(6) - round_sorted[0].last(3)) +
        (round_sorted[1].last(6) - round_sorted[0].last(3)) +
        (round_sorted[2].last(5) - round_sorted[0].last(3))
      ).collect(&:first).sort
      bronze_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 27
      # Method: Top 4 court leaders, combine remaining in descending order
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3) + round_sorted[2].first(3)).collect(&:first).sort
      silver_ids = (
        (round_sorted[0].last(6) - round_sorted[0].last(3)) +
        (round_sorted[1].last(6) - round_sorted[0].last(3)) +
        (round_sorted[2].last(6) - round_sorted[0].last(3))
      ).collect(&:first).sort
      bronze_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    end
  end

  def self.new_round(players)
    # binding.pry
    case players[:ids].count
    when 4
      { court1: players[:ids].shuffle, court2: [] }
    when 5
      { court1: players[:ids].shuffle, court2: [] }
    when 6
      { court1: players[:ids].shuffle, court2: [] }
    when 7
      { court1: players[:ids].shuffle, court2: [] }
    when 8
      { court1: players[:ids].shuffle, court2: [] }
    when 9
      { court1: players[:ids].shuffle, court2: [] }
    when 10
      { court1: players[:ids], court2: players[:ids] }
    when 11
      { court1: players[:ids], court2: players[:ids] }
    when 12
      { court1: players[:ids], court2: players[:ids] }
    when 13
      { court1: players[:ids], court2: players[:ids] }
    when 14
      { court1: players[:ids], court2: players[:ids] }
    when 15
      { court1: players[:ids], court2: players[:ids] }
    ##########
    # when 16 # players_count_16_17
    #   { court1: players[:ids].first(8) + [players[:ghosts].first], court2: players[:ids].last(8) + [players[:ghosts].last(1)] }
    # when 17
    #   { court1: players[:ids].first(9), court2: players[:ids].last(8) + players[:ghosts].last(1) }
    # when 18 # players_count_18_21
    #   { court1: players[:ids][0..5] + [players[:ghosts].first], court2: players[:ids][6..11] + [players[:ghosts].second], court3: players[:ids][12..17] + [players[:ghosts].last(1)] }
    # when 19
    #   { court1: players[:ids][0..6], court2: players[:ids][7..12] + [players[:ghosts].first], court3: players[:ids][13..18] + [players[:ghosts].last(1)] }
    # when 20
    #   { court1: players[:ids][0..6], court2: players[:ids][7..13], court3: players[:ids][14..19] + [players[:ghosts].last(1)] }
    # when 21
    #   { court1: players[:ids][0..6], court2: players[:ids][7..13], court3: players[:ids][14..20] }
    # when 22 # players_count_22_24
    #   { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..16] + [players[:ghosts].first], court4: players[:ids][17..21] + [players[:ghosts].last(1)] }
    # when 23
    #   { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..17], court4: players[:ids][18..22] + [players[:ghosts].last(1)] }
    # when 24
    #   { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..17], court4: players[:ids][18..23] }
    # when 25 # players_count_25_27
    #   { court1: players[:ids][0..8], court2: players[:ids][9..16] + [players[:ghosts].first], court3: players[:ids][17..24] + [players[:ghosts].last(1)] }
    # when 26
    #   { court1: players[:ids][0..8], court2: players[:ids][9..17], court3: players[:ids][18..25] + [players[:ghosts].last(1)] }
    # when 27
    #   { court1: players[:ids][0..8], court2: players[:ids][9..17], court3: players[:ids][18..26] }
    end
  end  


  # Tab indexes
  # This configuration is for multi-court tournaments to override default tab order,
  # to tab horizontally across both tables.
  def self.tab
    [
      [
        [1, 2],
        [5, 6],
        [9, 10],
        [13, 14],
        [17, 18],
        [21, 22],
        [25, 26],
        [29, 30],
        [33, 34],
        [37, 38],
        [41, 42],
        [45, 46]
      ],
      [
        [3, 4],
        [7, 8],
        [11, 12],
        [15, 16],
        [19, 20],
        [23, 24],
        [27, 28],
        [31, 32],
        [35, 36],
        [39, 40],
        [43, 44],
        [47, 48]
      ]
    ]
  end
end


# 8 player
# (8 5 1 6) : (2 3 4 7)
# (8 6 2 7) : (3 4 5 1)
# (8 7 3 1) : (4 5 6 2)
# (8 1 4 2) : (5 6 7 3)
# (8 2 5 3) : (6 7 1 4)
# (8 3 6 4) : (7 1 2 5)
# (8 4 7 5) : (1 2 3 6)



# 11 player
# Table 1          Table 2          Byes
# ( 6  4 v  7  2)  (11  1 v  9  5)  ( 8  3 10)
# ( 7  5 v  8  3)  ( 1  2 v 10  6)  ( 9  4 11)
# ( 8  6 v  9  4)  ( 2  3 v 11  7)  (10  5  1)
# ( 9  7 v 10  5)  ( 3  4 v  1  8)  (11  6  2)
# (10  8 v 11  6)  ( 4  5 v  2  9)  ( 1  7  3)
# (11  9 v  1  7)  ( 5  6 v  3 10)  ( 2  8  4)
# ( 1 10 v  2  8)  ( 6  7 v  4 11)  ( 3  9  5)
# ( 2 11 v  3  9)  ( 7  8 v  5  1)  ( 4 10  6)
# ( 3  1 v  4 10)  ( 8  9 v  6  2)  ( 5 11  7)
# ( 4  2 v  5 11)  ( 9 10 v  7  3)  ( 6  1  8)
# ( 5  3 v  6  1)  (10 11 v  8  4)  ( 7  2  9)


# 12 player, 11 round  
# ( 2  3  9 v  7 10  1)  ( 8  5  6 v 12  4 11)
# ( 3  4 10 v  8 11  2)  ( 9  6  7 v 12  5  1)
# ( 4  5 11 v  9  1  3)  (10  7  8 v 12  6  2)
# ( 5  6  1 v 10  2  4)  (11  8  9 v 12  7  3)
# ( 6  7  2 v 11  3  5)  ( 1  9 10 v 12  8  4)
# ( 7  8  3 v  1  4  6)  ( 2 10 11 v 12  9  5)
# ( 8  9  4 v  2  5  7)  ( 3 11  1 v 12 10  6)
# ( 9 10  5 v  3  6  8)  ( 4  1  2 v 12 11  7)
# (10 11  6 v  4  7  9)  ( 5  2  3 v 12  1  8)
# (11  1  7 v  5  8 10)  ( 6  3  4 v 12  2  9)
# ( 1  2  8 v  6  9 11)  ( 7  4  5 v 12  3 10)

# 13 players, triples, 13 rounds
# Court 1               Court 2           Bye
# ( 2 11  4], [ 13  5 10) ( 6  7  8], [ 12  3  9)   ( 1)
# ( 3 12  5], [  1  6 11) ( 7  8  9], [ 13  4 10)   ( 2)
# ( 4 13  6], [  2  7 12) ( 8  9 10], [  1  5 11)   ( 3)
# ( 5  1  7], [  3  8 13) ( 9 10 11], [  2  6 12)   ( 4)
# ( 6  2  8], [  4  9  1) (10 11 12], [  3  7 13)   ( 5)
# ( 7  3  9], [  5 10  2) (11 12 13], [  4  8  1)   ( 6)
# ( 8  4 10], [  6 11  3) (12 13  1], [  5  9  2)   ( 7)
# ( 9  5 11], [  7 12  4) (13  1  2], [  6 10  3)   ( 8)
# (10  6 12], [  8 13  5) ( 1  2  3], [  7 11  4)   ( 9)
# (11  7 13], [  9  1  6) ( 2  3  4], [  8 12  5)   (10)
# (12  8  1], [ 10  2  7) ( 3  4  5], [  9 13  6)   (11)
# (13  9  2], [ 11  3  8) ( 4  5  6], [ 10  1  7)   (12)
# ( 1 10  3], [ 12  4  9) ( 5  6  7], [ 11  2  8)   (13)

#14 players triples, 2 byes, 14 rounds
# (8 1 12 v 13 11 7) (9 14 6 v 4 3 2) (5 10)
# (9 2 13 v 14 12 8) (10 1 7 v 5 4 3) (6 11)
# (10 3 14 v 1 13 9) (11 2 8 v 6 5 4) (7 12)
# (11 4 1 v 2 14 10) (12 3 9 v 7 6 5) (8 13)
# (12 5 2 v 3 1 11) (13 4 10 v 8 7 6) (9 14)
# (13 6 3 v 4 2 12) (14 5 11 v 9 8 7) (10 1)
# (14 7 4 v 5 3 13) (1 6 12 v 10 9 8) (11 2)
# (1 8 5 v 6 4 14) (2 7 13 v 11 10 9) (12 3)
# (2 9 6 v 7 5 1) (3 8 14 v 12 11 10) (13 4)
# (3 10 7 v 8 6 2) (4 9 1 v 13 12 11) (14 5)
# (4 11 8 v 9 7 3) (5 10 2 v 14 13 12) (1 6)
# (5 12 9 v 10 8 4) (6 11 3 v 1 14 13) (2 7)
# (6 13 10 v 11 9 5) (7 12 4 v 2 1 14) (3 8)
# (7 14 11 v 12 10 6) (8 13 5 v 3 2 1) (4 9)


# 15 players, triples, 3 byes, 2 courts 10 rounds
# ( 8  7  2 v 14  6  9) (11  4 10 v 13  5 15)   ( 1 12  3)
# ( 9  8  3 v 15  7 10) (12  5  6 v 14  1 11)   ( 2 13  4)
# (10  9  4 v 11  8  6) (13  1  7 v 15  2 12)   ( 3 14  5)
# ( 6 10  5 v 12  9  7) (14  2  8 v 11  3 13)   ( 4 15  1)
# ( 7  6  1 v 13 10  8) (15  3  9 v 12  4 14)   ( 5 11  2)

# ( 2  3  1 v 11  5  9) (12  8 10 v 13 14  4)   ( 6  7 15)
# ( 3  4  2 v 12  1 10) (13  9  6 v 14 15  5)   ( 7  8 11)
# ( 4  5  3 v 13  2  6) (14 10  7 v 15 11  1)   ( 8  9 12)
# ( 5  1  4 v 14  3  7) (15  6  8 v 11 12  2)   ( 9 10 13)
# ( 1  2  5 v 15  4  8) (11  7  9 v 12 13  3)   (10  6 14)



# 16 players 2 courts quad teams
# ( 5  1 14  9 v 16  7  4  8) ( 3 15 13  6 v  2 10 11 12)
# ( 6  2 15 10 v 16  8  5  9) ( 4  1 14  7 v  3 11 12 13)
# ( 7  3  1 11 v 16  9  6 10) ( 5  2 15  8 v  4 12 13 14)
# ( 8  4  2 12 v 16 10  7 11) ( 6  3  1  9 v  5 13 14 15)
# ( 9  5  3 13 v 16 11  8 12) ( 7  4  2 10 v  6 14 15  1)
# (10  6  4 14 v 16 12  9 13) ( 8  5  3 11 v  7 15  1  2)
# (11  7  5 15 v 16 13 10 14) ( 9  6  4 12 v  8  1  2  3)
# (12  8  6  1 v 16 14 11 15) (10  7  5 13 v  9  2  3  4)
# (13  9  7  2 v 16 15 12  1) (11  8  6 14 v 10  3  4  5)
# (14 10  8  3 v 16  1 13  2) (12  9  7 15 v 11  4  5  6)
# (15 11  9  4 v 16  2 14  3) (13 10  8  1 v 12  5  6  7)
# ( 1 12 10  5 v 16  3 15  4) (14 11  9  2 v 13  6  7  8)
# ( 2 13 11  6 v 16  4  1  5) (15 12 10  3 v 14  7  8  9)
# ( 3 14 12  7 v 16  5  2  6) ( 1 13 11  4 v 15  8  9 10)
# ( 4 15 13  8 v 16  6  3  7) ( 2 14 12  5 v  1  9 10 11)
