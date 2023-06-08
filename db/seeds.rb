puts "== Creating Users..."

# Admins
dan = User.create(email: 'dmbrooking@gmail.com', first_name: 'Dan', last_name: 'Brooking', password: 'password', password_confirmation: 'password')
adam = User.create(email: 'adam@freemer.com', first_name: 'Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')

[dan, adam].each do |user|
  user.add_role :admin
end

coach_adam = User.create(email: 'coach@freemer.com', first_name: 'Coach Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
coach_dan = User.create(email: 'coach@dan.com', first_name: 'Coach Dan', last_name: 'Brooking', password: 'password', password_confirmation: 'password')
coach_adam.add_role :coach
coach_dan.add_role :coach

team = Team.create(name: "Primary", description: "Primary Team", coach_id: coach_adam.id)
second_team = Team.create(name: "Second Team", description: "Second Team", coach_id: coach_adam.id)


# [l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11].each do |player|
#   player.teams << team
#   player.save
# end

# [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11].each do |player|
#   player.teams << second_team
#   player.save
# end

User.create(email: 'coachgel@test.com', first_name: 'Dan', last_name: 'Z', password: 'password', password_confirmation: 'password')
User.create(email: 'tyler@test.com', first_name: 'Adam', last_name: 'Y', password: 'password', password_confirmation: 'password')
User.create(email: 'lauren@test.com', first_name: 'Bill', last_name: 'D', password: 'password', password_confirmation: 'password')
User.create(email: 'naomi@test.com', first_name: 'Pat', last_name: 'W', password: 'password', password_confirmation: 'password')
User.create(email: 'analee@test.com', first_name: 'Tim', last_name: 'R', password: 'password', password_confirmation: 'password')
User.create(email: 'evelyn@test.com', first_name: 'Ahmed', last_name: 'W', password: 'password', password_confirmation: 'password')
User.create(email: 'jessica@test.com', first_name: 'Steve', last_name: 'A', password: 'password', password_confirmation: 'password')
User.create(email: 'gianna@test.com', first_name: 'Wil', last_name: 'H', password: 'password', password_confirmation: 'password')
User.create(email: 'kendall@test.com', first_name: 'Ken', last_name: 'L', password: 'password', password_confirmation: 'password')
User.create(email: 'are@test.com', first_name: 'Matt ', last_name: 'M', password: 'password', password_confirmation: 'password')
User.create(email: 'mila@test.com ', first_name: 'Joe', last_name: 'C', password: 'password', password_confirmation: 'password')
User.create(email: 'kylie@test.com', first_name: 'Dean', last_name: 'Y', password: 'password', password_confirmation: 'password')
User.create(email: 'mika@test.com', first_name: 'Bob', last_name: 'N', password: 'password', password_confirmation: 'password')

# Ghost Users
User.create(email: '_ghost_player1@mail.com', first_name: 'ghost_player1', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player2@mail.com', first_name: 'ghost_player2', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player3@mail.com', first_name: 'ghost_player3', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player4@mail.com', first_name: 'ghost_player4', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player5@mail.com', first_name: 'ghost_player5', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player6@mail.com', first_name: 'ghost_player6', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)

puts "== Created #{User.count} users. ===================="
