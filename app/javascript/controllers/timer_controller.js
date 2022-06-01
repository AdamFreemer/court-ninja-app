import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentId: Number,
    breakTime: Number, 
    tournamentTime: Number,
    tournamentTimer: Number, 
    tournamentTimerState: String, // initial, run, stop, reset | initial is on tourney load to not auto-start on tourney creation
    tournamentTimerMode: { type: String, default: "break" }, // break, tournament
  }
  static targets = [ "minute", "second" ]

  // tournament state management
  // state = "initial", mode = "break" (New Tournament created) |  tournament display page holds with break time displayed
  // state = "run", mode = "break" (Tournament countdown) | Initial click to start break countdown
  // state = 'run", mode = "tournament" (Tournament start) | Tournament started 


  connect() {
    console.log("breakTime: ", this.breakTimeValue)
    console.log("tournamentTime: ", this.tournamentTimeValue)
    console.log("tournamentTimer: ", this.tournamentTimerValue)
    console.log("tournamentTimerState: ", this.tournamentTimerStateValue)
    console.log("tournamentTimerMode: ", this.tournamentTimerModeValue)
    this.generateTime();
    this.autoStart();

  }

  start() {
    this.timerOperation("initial", "run");
    // this.tournamentTimerModeValue = "run"
    // this.timer = setInterval(() => {
    //   this.update();
    // }, 1000);
  }

  autoStart() {
    if (!this.timer && !this.tournamentTimerStateValue == "initial") {
      this.start();
    }
  }

  pause() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    console.log("== pause")
  }

  update() {
    this.tournamentTimerValue--
    this.generateTime();

    if (this.tournamentTimerValue == 0 && this.tournamentTimerMode == "break") {

    } else if (this.tournamentTimerValue == 0 && this.tournamentTimerMode == "tournament") {

    }
  }

  generateTime() {  
    let time;
    this.tournamentTimerState == "initial" ? time = this.breakTimeValue : time  = this.tournamentTimerValue;
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
  }

  reset() {
    console.log("== reset")
  }


  timerOperation(state, mode) {
    console.log('== operation server update: ' + state + '/' + mode)
    $.ajax({
      type: "POST",
      url: "/tournaments/timer_operation",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
        state: state,
        mode: mode,
      },
      success: function (response) {
        console.log('== timer operation response: ' + response.timer_status)
      }
    })
  };
}