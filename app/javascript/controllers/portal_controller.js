import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  newTournamentClick() {
    window.location.href = `/tournaments/new/?type=standard`
  }

  newAdhocTournamentClick() {
    window.location.href = `/tournaments/new/?type=adhoc`
  }

  newTeamClick() {
    window.location.href = `/teams/new`
  }
}
