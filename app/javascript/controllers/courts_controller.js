import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    numCourts: { type: Number, default: 1 }
  };

  static targets = [
    "courtOneContainer",
    "courtTwoContainer",
    "courtThreeContainer",
    "courtFourContainer",
    "courtFiveContainer",
    "courtSixContainer",
  ];

  connect() {
    this.setDefaultCourtCount(this.numCourtsValue);
  }

  setDefaultCourtCount(numCourts) {
    if (numCourts > 2) numCourts === 1;

    this.constructor.targets.slice(0, numCourts).forEach(target => {
      this[`${target}Target`].classList.remove("hidden");
    });

    this.constructor.targets.slice(numCourts, this.constructor.targets.length).forEach(target => {
      this[`${target}Target`].classList.add("hidden");
    });
  }
}
