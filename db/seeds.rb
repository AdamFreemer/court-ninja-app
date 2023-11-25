puts "== Creating Users..."

# Admins
dan = User.create(email: 'dmbrooking@gmail.com', first_name: 'Dan', last_name: 'Brooking', password: 'password', password_confirmation: 'password')
adam = User.create(email: 'adam@freemer.com', first_name: 'Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
gary = User.create(email: 'gary@freemer.com', first_name: 'Gary', last_name: 'Freemer', password: 'password', password_confirmation: 'password')

[adam, dan].each do |user|
  user.is_admin = true
  user.is_coach = true
  user.save
end

#Adam Players
User.create(email: 'tyler@test.com', first_name: 'Tyler', last_name: 'Y', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'lauren@test.com', first_name: 'Lauren', last_name: 'D', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'patw@test.com', first_name: 'Pat', last_name: 'W', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'pat@test.com', first_name: 'Pat', last_name: 'R', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'ahmed@test.com', first_name: 'Ahmed', last_name: 'W', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'steve@test.com', first_name: 'Steve', last_name: 'A', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'wil@test.com', first_name: 'Wil', last_name: 'H', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'wil@test.com', first_name: 'Wil', last_name: 'L', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'matt@test.com', first_name: 'Matt ', last_name: 'M', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'joe@test.com ', first_name: 'Joe', last_name: 'C', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'dean@test.com', first_name: 'Dean', last_name: 'Y', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'bob@test.com', first_name: 'Bob', last_name: 'N', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'dave@test.com', first_name: 'Dave', last_name: 'Y', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)
User.create(email: 'beks@test.com', first_name: 'Beks', last_name: 'N', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id)

User.create(email: 'tempg@test.com', first_name: 'Temp', last_name: 'G', password: 'password', password_confirmation: 'password', is_player: true, coach_id: adam.id, is_one_off: true)

# Dan Players
User.create(email: 'christiano@test.com', first_name: 'Christian', last_name: 'Y', password: 'password', password_confirmation: 'password', is_player: true, coach_id: dan.id)
User.create(email: 'messi@test.com', first_name: 'Lionel', last_name: 'N', password: 'password', password_confirmation: 'password', is_player: true, coach_id: dan.id)

# Ghost Users
User.create(email: '_ghost_player1@mail.com', first_name: 'ghost_player1', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player2@mail.com', first_name: 'ghost_player2', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player3@mail.com', first_name: 'ghost_player3', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player4@mail.com', first_name: 'ghost_player4', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player5@mail.com', first_name: 'ghost_player5', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)
User.create(email: '_ghost_player6@mail.com', first_name: 'ghost_player6', last_name: '-', password: 'password', password_confirmation: 'password', is_ghost_player: true)

puts "== Created #{User.count} users. ===================="
