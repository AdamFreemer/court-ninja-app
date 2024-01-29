puts "== Creating Users..."

# Admins
dan = User.create(email: 'dmbrooking@gmail.com', first_name: 'Dan', last_name: 'Brooking', password: 'password', password_confirmation: 'password')
adam = User.create(email: 'adam@freemer.com', first_name: 'Adam', last_name: 'Freemer', password: 'password', password_confirmation: 'password')
gary = User.create(email: 'gary@freemer.com', first_name: 'Gary', last_name: 'Freemer', password: 'password', password_confirmation: 'password', is_coach: true)

[adam, dan].each do |user|
  user.is_admin = true
  user.is_coach = true
  user.save
end

#Adam Players
User.create(email: 'tyler@test.com', first_name: 'Tyler', last_name: 'Yahoda', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'lauren@test.com', first_name: 'Lauren', last_name: 'Deeker', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'patw@test.com', first_name: 'Pat', last_name: 'Wilkes', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'pat@test.com', first_name: 'Pat', last_name: 'Roden', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'ahmed@test.com', first_name: 'Ahmed', last_name: 'Weebley', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'steve@test.com', first_name: 'Steve', last_name: 'Austin', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'wil@test.com', first_name: 'Wil', last_name: 'Iam', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'wil@test.com', first_name: 'Wil', last_name: 'Smith', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'matt@test.com', first_name: 'Matt ', last_name: 'Moheki', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'joe@test.com ', first_name: 'Joe', last_name: 'Blow', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'dean@test.com', first_name: 'Dean', last_name: 'Yaritz', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'bob@test.com', first_name: 'Bob', last_name: 'Shouster', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'dave@test.com', first_name: 'Dave', last_name: 'Fitzpatrick', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)
User.create(email: 'beks@test.com', first_name: 'Beks', last_name: 'Nevaro', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id)

User.create(email: 'tempg@test.com', first_name: 'Gotce', last_name: 'Peev', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: gary.id, is_one_off: true)

# Dan Players
User.create(email: 'christiano@test.com', first_name: 'Christian', last_name: 'Y', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: dan.id)
User.create(email: 'messi@test.com', first_name: 'Lionel', last_name: 'N', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_player: true, coach_id: dan.id)

# Ghost Users
User.create(email: '_ghost_player1@mail.com', first_name: 'ghost_player1', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)
User.create(email: '_ghost_player2@mail.com', first_name: 'ghost_player2', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)
User.create(email: '_ghost_player3@mail.com', first_name: 'ghost_player3', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)
User.create(email: '_ghost_player4@mail.com', first_name: 'ghost_player4', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)
User.create(email: '_ghost_player5@mail.com', first_name: 'ghost_player5', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)
User.create(email: '_ghost_player6@mail.com', first_name: 'ghost_player6', last_name: '-', password: 'gofuckyourself', password_confirmation: 'gofuckyourself', is_ghost_player: true)

puts "== Created #{User.count} users. ===================="
