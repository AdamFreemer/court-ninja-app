class AddCourtRoundToTournamentTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_teams, :court, :integer
    add_column :tournament_teams, :round, :integer
  end
end
