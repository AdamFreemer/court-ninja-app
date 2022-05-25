import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { time: Number, status: String }
  static targets = [ "minute", "second" ]

  connect() {
    console.log("-- connect!")
    console.log("-- this.timeValue: " + this.timeValue)
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
    console.log("-- this.timeValue: " + this.timeValue)
    console.log("-- this.statusValue: " + this.statusValue)
    this.timeValue--
    this.generateTime();
  }

  generateTime() {
    var second = this.timeValue % 60;
    var minute = Math.floor(this.timeValue / 60) % 60;

    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    console.log('-- ' + minute + ":" + second)
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
  }

  reset() {
    console.log("== reset")
  }
}