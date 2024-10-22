import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  newTournamentTeamClick() {
    // TODO validate a team selected
    window.location.href = `/tournaments/new?type=team`
  }

  newTournamentPlayerClick() {
    window.location.href = `/tournaments/new?type=player`
  }

  newAdhocTournamentClick() {
    window.location.href = `/tournaments/new`
  }

  newTeamClick() {
    window.location.href = `/teams/new`
  }
}
