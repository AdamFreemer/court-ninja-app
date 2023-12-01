import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  newTournamentClick() {
    window.location.href = `/tournaments/new`
  }

  newAdhocTournamentClick() {
    window.location.href = `/tournaments/new`
  }

  newTeamClick() {
    window.location.href = `/teams/new`
  }
}
