module PlayerConfigs
  # tournament configurations
  # These arrays are based off the bjerring tables: https://vbc.cyburi.com/resource/LinearRankingTournament.pdf
  # For each row, 1st array is Team 1, 2nd array is Team 2. If there's a work (non-playing) Team, that is the 3rd array.
  
# 8 player
# (8 5 1 6) : (2 3 4 7)
# (8 6 2 7) : (3 4 5 1)
# (8 7 3 1) : (4 5 6 2)
# (8 1 4 2) : (5 6 7 3)
# (8 2 5 3) : (6 7 1 4)
# (8 3 6 4) : (7 1 2 5)
# (8 4 7 5) : (1 2 3 6)



# 11
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

# 12 player, 11 round solution for 10-12 players
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

# 13 players
# ( 0  1  4)  v  ( 3  5 10)
# ( 1  2  5)  v  ( 4  6 11)
# ( 2  3  6)  v  ( 5  7 12)
# ( 3  4  7)  v  ( 6  8  0)
# ( 4  5  8)  v  ( 7  9  1)
# ( 5  6  9)  v  ( 8 10  2)
# ( 6  7 10)  v  ( 9 11  3)
# ( 7  8 11)  v  (10 12  4)
# ( 8  9 12)  v  (11  0  5)
# ( 9 10  0)  v  (12  1  6)
# (10 11  1)  v  ( 0  2  7)
# (11 12  2)  v  ( 1  3  8)
# (12  0  3)  v  ( 2  4  9)

#14 players
# Table 1         Table 2          Table 3        Byes
# (5 10 : 1 12)  ( 3 13 :  0  9)  ( 6  4 :  7 11)   ( 2  8)
# (6 11 : 2 13)  ( 4  7 :  1 10)  ( 0  5 :  8 12)   ( 3  9)
# (0 12 : 3  7)  ( 5  8 :  2 11)  ( 1  6 :  9 13)   ( 4 10)
# (1 13 : 4  8)  ( 6  9 :  3 12)  ( 2  0 : 10  7)   ( 5 11)
# (2  7 : 5  9)  ( 0 10 :  4 13)  ( 3  1 : 11  8)   ( 6 12)
# (3  8 : 6 10)  ( 1 11 :  5  7)  ( 4  2 : 12  9)   ( 0 13)
# (4  9 : 0 11)  ( 2 12 :  6  8)  ( 5  3 : 13 10)   ( 1  7)
# (2  5 : 3  4)  (13 12 :  7  1)  ( 9 11 :  8  0)   (10  6)
# (3  6 : 4  5)  ( 7 13 :  8  2)  (10 12 :  9  1)   (11  0)
# (4  0 : 5  6)  ( 8  7 :  9  3)  (11 13 : 10  2)   (12  1)
# (5  1 : 6  0)  ( 9  8 : 10  4)  (12  7 : 11  3)   (13  2)
# (6  2 : 0  1)  (10  9 : 11  5)  (13  8 : 12  4)   ( 7  3)
# (0  3 : 1  2)  (11 10 : 12  6)  ( 7  9 : 13  5)   ( 8  4)
# (1  4 : 2  3)  (12 11 : 13  0)  ( 8 10 :  7  6)   ( 9  5)

# 15 players
# court 1        court 2         court 3           byes
# ( 4 14 v 15  1) ( 6  2 v 10  7) (13  3 v  5  8)   (12 11  9)
# ( 5 15 v 13  2) ( 4  3 v 11  8) (14  1 v  6  9)   (10 12  7)
# ( 6 13 v 14  3) ( 5  1 v 12  9) (15  2 v  4  7)   (11 10  8)
# ( 7  6 v 15  4) ( 3  2 v 14 12) (10  8 v  1 11)   ( 9 13  5)
# ( 8  4 v 13  5) ( 1  3 v 15 10) (11  9 v  2 12)   ( 7 14  6)
# ( 9  5 v 14  6) ( 2  1 v 13 11) (12  7 v  3 10)   ( 8 15  4)
# ( 1  4 v 12  3) (14 15 v 11  5) ( 8  6 v  2  7)   (13 10  9)
# ( 2  5 v 10  1) (15 13 v 12  6) ( 9  4 v  3  8)   (14 11  7)
# ( 3  6 v 11  2) (13 14 v 10  4) ( 7  5 v  1  9)   (15 12  8)
# ( 7  9 v 13 10) ( 2 14 v  1 15) ( 6  5 v 12  8)   ( 3 11  4)
# ( 8  7 v 14 11) ( 3 15 v  2 13) ( 4  6 v 10  9)   ( 1 12  5)
# ( 9  8 v 15 12) ( 1 13 v  3 14) ( 5  4 v 11  7)   ( 2 10  6)
# (10  6 v  5  3) ( 4 13 v  2  9) (12 11 v 14  7)   (15  8  1)
# (11  4 v  6  1) ( 5 14 v  3  7) (10 12 v 15  8)   (13  9  2)
# (12  5 v  4  2) ( 6 15 v  1  8) (11 10 v 13  9)   (14  7  3)
# (10  2 v  8 14) (13 12 v  6 11) ( 7 15 v  3  9)   ( 4  5  1)
# (11  3 v  9 15) (14 10 v  4 12) ( 8 13 v  1  7)   ( 5  6  2)
# (12  1 v  7 13) (15 11 v  5 10) ( 9 14 v  2  8)   ( 6  4  3)

###### Notes
###### [side 1], [side 2], [byes]
###### Courts are grouped per each

def self.p5
  # 5 matches
  [
    [[1, 2], [3, 4], [5]],
    [[2, 5], [1, 3], [4]],
    [[3, 5], [1, 4], [2]],
    [[1, 5], [2, 4], [3]],
    [[2, 3], [4, 5], [1]]
  ]
end  

def self.p6
  # 10 matches
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
  # 7 matches
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

  def self.p9
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

  def self.p10
    [
      [
        [[1,  5], [7, 10], [ 2]],
        [[2,  1], [8,  6], [ 3]],
        [[3,  2], [9,  7], [ 4]],
        [[4,  3], [10, 8], [ 5]],
        [[5,  4], [6,  9], [ 1]],
        [[7,  6], [4,  8], [10]],
        [[8,  7], [5,  9], [ 6]],
        [[9,  8], [1, 10], [ 7]],
        [[10, 9], [2,  6], [ 8]],
        [[6, 10], [3,  7], [ 9]]
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

  def self.p12
    [
      [
        [[2, 3, 9], [7, 10, 1], []],
        [[3, 4, 10], [8, 11, 2], []],
        [[4, 5, 11], [9, 1, 3], []],
        [[5, 6, 1], [10, 2, 4], []],
        [[6, 7, 2], [11, 3, 5], []],
        [[7, 8, 3], [1, 4, 6], []],
        [[8, 9, 4], [2, 5, 7], []],
        [[9, 10, 5], [3, 6, 8], []],
        [[10, 11, 6], [4, 7, 9], []],
        [[11, 1, 7], [5, 8, 10], []],
        [[1, 2, 8], [6, 9, 11], []]
      ],
      [
        [[8, 5, 6], [12, 4, 11], []],
        [[9, 6, 7], [12, 5, 1], []],
        [[10, 7, 8], [12, 6, 2], []],
        [[11, 8, 9], [12, 7, 3], []],
        [[1, 9, 10], [12, 8, 4], []],
        [[2, 10, 11], [12, 9, 5], []],
        [[3, 11, 1], [12, 10, 6], []],
        [[4, 1, 2], [12, 11, 7], []],
        [[5, 2, 3], [12, 1, 8], []],
        [[6, 3, 4], [12, 2, 9], []],
        [[7, 4, 5], [12, 3, 10], []]
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
    when 5 # players_count_5
      { court1: players[:ids].shuffle, court2: [] }
    when 6 # players_count_6
      { court1: players[:ids].shuffle, court2: [] }
    when 7 # players_count_7
      { court1: players[:ids].shuffle, court2: [] }
    when 8 # players_count_8_9
      { court1: players[:ids].first(8) + [players[:ghosts].first], court2: [] }
    when 9
      { court1: players[:ids].first(9), court2: [] }
    when 10
      { court1: players[:ids] + players[:ghosts].first(2), court2: players[:ids] + players[:ghosts].first(2) }
    when 11
      { court1: players[:ids] + players[:ghosts], court2: players[:ids] + players[:ghosts] }
    when 12
      { court1: players[:ids], court2: players[:ids] }
    when 13
      { court1: players[:ids].first(7), court2: players[:ids].last(6) + [players[:ghosts].last(1)] }
    when 14
      { court1: players[:ids].first(7), court2: players[:ids].last(7) }
    ####
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
