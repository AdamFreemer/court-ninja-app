puts "== Creating Users..."

# Admins
dan = User.create(email: 'dmbrooking@gmail.com', first_name: 'Dan', last_name: 'Broking', password: 'password', password_confirmation: 'password')
adam = User.create(email: 'adam@freemer.com', first_name: 'Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
lucky = User.create(email: 'lucky@2629consulting.com', first_name: 'Lucky', last_name: 'Makropoulos', password: 'password', password_confirmation: 'password')

[dan, adam, lucky].each do |user|
  user.add_role :admin
end

coach_adam = User.create(email: 'coach@freemer.com', first_name: 'Coach Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
coach_adam.add_role :coach

team = Team.create(name: "Primary", description: "Primary Team", coach_id: coach_adam.id)

# Lucky Team
l1 = User.create(email: 'sfaisal2007@yahoo.com', first_name: 'Olivia', last_name: 'Luey', password: 'password', password_confirmation: 'password')
l2 = User.create(email: 'bollinger.ohana@gmail.com', first_name: 'Brooklyn', last_name: 'Bollinger', password: 'password', password_confirmation: 'password')
l3 = User.create(email: 'hi@regandaniels.com', first_name: 'Julia', last_name: 'Qaqundah', password: 'password', password_confirmation: 'password')
l4 = User.create(email: 'marcy.l.lim@gmail.com', first_name: 'Maddy', last_name: 'Ho', password: 'password', password_confirmation: 'password')
l5 = User.create(email: 'carol@comebuyusa.com', first_name: 'Clare', last_name: 'Wang', password: 'password', password_confirmation: 'password')
l6 = User.create(email: 'campme00@hotmail.com', first_name: 'Samantha', last_name: 'Hegel', password: 'password', password_confirmation: 'password')
l7 = User.create(email: 'kanoti.kim@gmail.com', first_name: 'Maddy', last_name: 'Kim', password: 'password', password_confirmation: 'password')
l8 = User.create(email: 'kristine.d.kirby@gmail.com', first_name: 'Kaylani', last_name: 'Kirby', password: 'password', password_confirmation: 'password')
l9 = User.create(email: 'chrisbrobertson@gmail.com', first_name: 'Catey', last_name: 'Robertson', password: 'password', password_confirmation: 'password')
l10 = User.create(email: 'letitiachan@yahoo.com', first_name: 'Sofia', last_name: 'Peypoch', password: 'password', password_confirmation: 'password')
l11 = User.create(email: 'kierstenmahon@mac.com', first_name: 'Hadley', last_name: 'Mahon', password: 'password', password_confirmation: 'password')
l12 = User.create(email: 'liongitau@gmail.com', first_name: 'Malianna', last_name: 'Liongitau', password: 'password', password_confirmation: 'password')
l13 = User.create(email: 'twschaumkel@gmail.com', first_name: 'Ella', last_name: 'Schaumkel', password: 'password', password_confirmation: 'password')
l14 = User.create(email: 'adam@freemer.com', first_name: 'Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
l15 = User.create(email: 'lucky@2629consulting.com', first_name: 'Lucky', last_name: 'Makropoulos', password: 'password', password_confirmation: 'password')

[l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11].each do |player|
  player.teams << team
  player.save
end


# 15 Jen Team
User.create(email: 'gia.r@gmail.com', first_name: 'Gia', last_name: 'R', password: 'password', password_confirmation: 'password')
User.create(email: 'cassidy.p@gmail.com', first_name: 'Cassidy', last_name: 'P', password: 'password', password_confirmation: 'password')
User.create(email: 'adrianna.a@gmail.com', first_name: 'Adrianna', last_name: 'A', password: 'password', password_confirmation: 'password')
User.create(email: 'sophie.p@gmail.com', first_name: 'Sophie', last_name: 'P', password: 'password', password_confirmation: 'password')
User.create(email: 'sophie.m@gmail.com', first_name: 'Sophie', last_name: 'M', password: 'password', password_confirmation: 'password')
User.create(email: 'rube.r@gmail.com', first_name: 'Rube', last_name: 'R', password: 'password', password_confirmation: 'password')
User.create(email: 'claire.s@gmail.com', first_name: 'Claire', last_name: 'S', password: 'password', password_confirmation: 'password')
User.create(email: 'alley.k@gmail.com', first_name: 'Alley', last_name: 'K', password: 'password', password_confirmation: 'password')
User.create(email: 'lily.k@gmail.com', first_name: 'Lily', last_name: 'K', password: 'password', password_confirmation: 'password')
User.create(email: 'poemma.u@gmail.com', first_name: 'Poemma', last_name: 'U', password: 'password', password_confirmation: 'password')
User.create(email: 'abby.m@gmail.com', first_name: 'Abby', last_name: 'M', password: 'password', password_confirmation: 'password')
User.create(email: 'bre.c@gmail.com', first_name: 'Bre', last_name: 'Coach', password: 'password', password_confirmation: 'password')
User.create(email: 'mikey.c@gmail.com', first_name: 'Mikey', last_name: 'Coach', password: 'password', password_confirmation: 'password')

# 16 Kimmy Guest Team
User.create(email: 'coachgel@test.com', first_name: 'Gel', last_name: 'Leano', password: 'password', password_confirmation: 'password')
User.create(email: 'tyler@test.com', first_name: 'Tyler/16K', last_name: 'Y', password: 'password', password_confirmation: 'password')
User.create(email: 'lauren@test.com', first_name: 'Lauren/16K', last_name: 'D', password: 'password', password_confirmation: 'password')
User.create(email: 'naomi@test.com', first_name: 'Naomi/16K', last_name: 'W', password: 'password', password_confirmation: 'password')
User.create(email: 'analee@test.com', first_name: 'AnaLee/16K', last_name: 'R', password: 'password', password_confirmation: 'password')
User.create(email: 'evelyn@test.com', first_name: 'Evelyn/16K', last_name: 'W', password: 'password', password_confirmation: 'password')
User.create(email: 'jessica@test.com', first_name: 'Jessica/16K', last_name: 'A', password: 'password', password_confirmation: 'password')
User.create(email: 'gianna@test.com', first_name: 'Gianna/16K', last_name: 'H', password: 'password', password_confirmation: 'password')
User.create(email: 'kendall@test.com', first_name: 'Kendall/16K', last_name: 'L', password: 'password', password_confirmation: 'password')
User.create(email: 'are@test.com', first_name: 'Are/16K ', last_name: 'M', password: 'password', password_confirmation: 'password')
User.create(email: 'mila@test.com ', first_name: 'Mila/16K', last_name: 'C', password: 'password', password_confirmation: 'password')
User.create(email: 'kylie@test.com', first_name: 'Kylie/16K', last_name: 'Y', password: 'password', password_confirmation: 'password')
User.create(email: 'mika@test.com', first_name: 'Mika/16K', last_name: 'N', password: 'password', password_confirmation: 'password')

# Ghost Users
User.create(email: '_ghost_player1@mail.com', first_name: 'ghost_player1', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player2@mail.com', first_name: 'ghost_player2', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player3@mail.com', first_name: 'ghost_player3', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player4@mail.com', first_name: 'ghost_player4', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player5@mail.com', first_name: 'ghost_player5', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player6@mail.com', first_name: 'ghost_player6', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)

puts "== Created #{User.count} users. ===================="

# Team 16 Walker
# Ally G. 
# Sam L. 
# Maddie L. 
# Sofia M. 
# Kaila E. 
# Sophia S. 
# Madi H. 
# Pailey D. 
# Ady V. 
# Sadie S. 
# Tangi N. 
# Elizabeth C

### Add players to team

# team = <existing team>
# [list of players].each do |p|
#   player = Player.new(.....)
#   player.teams << team
#   player.save
# end