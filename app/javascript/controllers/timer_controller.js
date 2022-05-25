import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { tournamentTime: Number, breakTime: Number, status: String }
  static targets = [ "minute", "second" ]

  connect() {
    console.log("-- connect!")
    console.log("-- this.timeValue: " + this.tournamentTimeValue)
    console.log("-- this.statusValue: " + this.statusValue)
  }

  start() {
    this.statusValue = "run"
    let timer = setInterval(() => {
      if (this.statusValue == "pause") {
        clearInterval(timer);
      }
      this.timerRun();
    }, 1000);    
  }

  pause() {
    this.statusValue = "pause"
    console.log("== pause")
  }

  timerRun() {
    console.log("-- this.timeValue: " + this.tournamentTimeValue)
    console.log("-- this.statusValue: " + this.statusValue)
    this.tournamentTimeValue--
    this.generateTime();
  }

  generateTime() {
    var second = this.tournamentTimeValue % 60;
    var minute = Math.floor(this.tournamentTimeValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
  }

  reset() {
    console.log("== reset")
  }
}