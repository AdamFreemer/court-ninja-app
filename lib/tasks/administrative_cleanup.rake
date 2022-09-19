require 'rake'
namespace :db do
  desc 'Set all nil break_time and tournament_time to 60 (seconds)'
  task update_tournament_times_to_match_times: :environment do
    puts "== Running Set all nil break_time and tournament_time to 60 (seconds)..."
    Tournament.all.each do |tournament|
      puts "== Executing on Tournament ID: #{tournament.id}"
      if tournament.match_time.blank?
        tournament.match_time = 60
        puts "== Updated match_time on Tournament ID: #{tournament.id}"
      end

      if tournament.pre_match_time.blank?
        tournament.pre_match_time = 60
        puts "== Updated pre_match_time on Tournament ID: #{tournament.id}"
      end
      tournament.save
    end
  end
end
