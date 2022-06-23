module PlayerConfigs
  # tournament configurations
  # These arrays are based off the bjerring tables: https://vbc.cyburi.com/resource/LinearRankingTournament.pdf
  # For each row, 1st array is Team 1, 2nd array is Team 2. If there's a work (non-playing) Team, that is the 3rd array.
  def self.p9 # 12 rounds
    [
      [[1, 4, 7], [2, 5, 9], [3, 6, 8]],
      [[1, 5, 8], [2, 6, 7], [3, 4, 9]],
      [[1, 6, 9], [2, 4, 8], [3, 5, 7]],
      [[2, 4, 8], [3, 5, 7], [1, 6, 9]],
      [[2, 5, 9], [3, 6, 8], [1, 4, 7]],
      [[2, 6, 7], [3, 4, 9], [1, 5, 8]],
      [[3, 4, 9], [1, 5, 8], [2, 6, 7]],
      [[3, 5, 7], [1, 6, 9], [2, 4, 8]],
      [[3, 6, 8], [1, 4, 7], [2, 5, 9]],
      [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
      [[4, 5, 6], [7, 8, 9], [1, 2, 3]],
      [[7, 8, 9], [1, 2, 3], [4, 5, 6]]
    ]
  end

  def self.p7 # 7 rounds
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

  def self.p6 # 10 rounds
    [
      [[1, 2, 3], [4, 5, 6], []],
      [[1, 2, 4], [3, 5, 6], []],
      [[1, 2, 5], [3, 4, 6], []],
      [[1, 2, 6], [3, 4, 5], []],
      [[1, 3, 4], [2, 5, 6], []],
      [[1, 3, 5], [2, 4, 6], []],
      [[1, 3, 6], [2, 4, 5], []],
      [[1, 4, 5], [2, 3, 6], []],
      [[1, 4, 6], [2, 3, 5], []],
      [[1, 5, 6], [2, 3, 4], []]
    ]
  end

  def self.p5
    [
      [[1, 2], [3, 4], [5]],
      [[1, 3], [2, 5], [4]],
      [[1, 4], [3, 5], [2]],
      [[1, 5], [2, 4], [3]],
      [[2, 3], [4, 5], [1]]
    ]
  end

  # Decision engine based on player count for pulling players from each court
  # for next round generation.
  def self.player_court_distributor(round_sorted, players)
    case round_sorted.flatten(1).count
    when 10 # players_count_10
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(2)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 11 # players_count_11_12
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 12
      gold_ids = (round_sorted[0].first(3) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 13 # players_count_13_14
      gold_ids = (round_sorted[0].first(4) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 14
      gold_ids = (round_sorted[0].first(4) + round_sorted[1].first(3)).collect(&:first).sort
      silver_ids = (players - gold_ids).sort
      gold_ids + silver_ids
    when 15 # players_count_15
      gold_ids = (round_sorted[0].first(4) + round_sorted[1].first(3)).collect(&:first).sort
    when 16 # players_count_16_17

    when 17

    when 18 # players_count_18_21

    when 19
 
    when 20

    when 21

    when 22 # players_count_22_24
      
    when 23
     
    when 24
   
    when 25 # players_count_25_27
 

    when 27

    end
  end

  ## After 
  def self.new_round(players)
    case players[:ids].count
    when 6 # players_count_6
      { court1: players[:ids], court2: [] }
    when 7 # players_count_7
      { court1: players[:ids], court2: [] }
    when 8 # players_count_8_9
      { court1: players[:ids].first(8) + [players[:ghosts].first], court2: [] }
    when 9
      { court1: players[:ids].first(9), court2: [] }
    when 10 # players_count_10
      { court1: players[:ids].first(5), court2: players[:ids].last(5) }
    when 11 # players_count_11_12
      # binding.pry
      { court1: players[:ids].first(6), court2: players[:ids].last(5) + [players[:ghosts].first] }
    when 12
      { court1: players[:ids].first(6), court2: players[:ids].last(6) }
    when 13 # players_count_13_14
      { court1: players[:ids].first(7), court2: players[:ids].last(6) + [players[:ghosts].last(1)] }
    when 14
      { court1: players[:ids].first(7), court2: players[:ids].last(7) }
    when 15 # players_count_15
      { court1: players[:ids][0..4], court2: players[:ids][5..9], court3: players[:ids][10..14] }
    when 16 # players_count_16_17
      { court1: players[:ids].first(8) + [players[:ghosts].first], court2: players[:ids].last(8) + [players[:ghosts].last(1)] }
    when 17
      { court1: players[:ids].first(9), court2: players[:ids].last(8) + players[:ghosts].last(1) }
    when 18 # players_count_18_21
      { court1: players[:ids][0..5] + [players[:ghosts].first], court2: players[:ids][6..11] + [players[:ghosts].second], court3: players[:ids][12..17] + [players[:ghosts].last(1)] }
    when 19
      { court1: players[:ids][0..6], court2: players[:ids][7..12] + [players[:ghosts].first], court3: players[:ids][13..18] + [players[:ghosts].last(1)] }
    when 20
      { court1: players[:ids][0..6], court2: players[:ids][7..13], court3: players[:ids][14..19] + [players[:ghosts].last(1)] }
    when 21
      { court1: players[:ids][0..6], court2: players[:ids][7..13], court3: players[:ids][14..20] }
    when 22 # players_count_22_24
      { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..16] + [players[:ghosts].first], court4: players[:ids][17..21] + [players[:ghosts].last(1)] }
    when 23
      { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..17], court4: players[:ids][18..22] + [players[:ghosts].last(1)] }
    when 24
      { court1: players[:ids][0..5], court2: players[:ids][6..11], court3: players[:ids][12..17], court4: players[:ids][18..23] }
    when 25 # players_count_25_27
      { court1: players[:ids][0..8], court2: players[:ids][9..16] + [players[:ghosts].first], court3: players[:ids][17..24] + [players[:ghosts].last(1)] }
    when 26
      { court1: players[:ids][0..8], court2: players[:ids][9..17], court3: players[:ids][18..25] + [players[:ghosts].last(1)] }
    when 27
      { court1: players[:ids][0..8], court2: players[:ids][9..17], court3: players[:ids][18..26] }
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
