import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "tournamentTime",
    "tournyBreakTime"
  ];

  connect() {
  }

  changeTournamentTime(event) {
    this.tournamentTimeTarget.value = event.target.value;
  }

  changeTournyBreakTime(event) {
    this.tournyBreakTime.value = event.target.value;
  }
}
