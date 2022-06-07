import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentId: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentRoundServer: Number,
    breakTime: Number, 
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial"
    tournamentTimerMode: { type: String, default: "break" }, // "break" or "run"
  }
  static targets = [ "minute", "second" ]

  connect() {
    console.log("breakTime: ", this.breakTimeValue)
    console.log("tournamentTime: ", this.tournamentTimeValue)
    console.log("tournamentTimer: ", this.tournamentTimerValue)
    console.log("tournamentTimerState: ", this.tournamentTimerStateValue)
    console.log("tournamentTimerMode: ", this.tournamentTimerModeValue)
    this.updatePage();
    this.autoStart();
  }

  start() {
    console.log("== start mode " + this.timer)
    let mode;
    this.tournamentTimerStateValue == "initial" ? mode = "break" : mode = this.tournamentTimerModeValue;
    this.timerOperation("run", mode, this.tournamentTimerValue);
    this.timer = setInterval(() => {
      this.update();
    }, 1000);
  }

  pause() {
    console.log("== pause" + "mode: " + this.tournamentTimerModeValue)
    if (this.timer) {
      clearInterval(this.timer);
    }
    this.timerOperation("stop", this.tournamentTimerModeValue, this.tournamentTimerValue);
  }

  reset() {
    console.log("== reset" + "mode: " + this.tournamentTimerModeValue)
    clearInterval(this.timer);
    this.timerOperation("stop", "break", this.breakTimeValue);
    this.updatePage();
  }

  autoStart() {
    if (!this.timer && !this.tournamentTimerStateValue == "initial") {
      this.start();
    }
    if (this.tournamentTimerStateValue == "run") {
      this.start();
    }
  }

  update() {
    this.tournamentTimerValue--
    this.updatePage();
    if (this.tournamentTimerValue == 0 && this.tournamentTimerModeValue == "break") {
      clearInterval(this.timer);
      this.tournamentTimerValue = this.tournamentTimeValue;
      this.timerOperation("run", "tournament", this.tournamentTimerValue);
      this.timer = setInterval(() => {
        this.update();
      }, 1000);
    } else if (this.tournamentTimerValue == 0 && this.tournamentTimerModeValue == "tournament") {
      clearInterval(this.timer);
      this.timerOperation("stop", "break", 0);
      this.tournamentTimerValue = 0;
    } else {
      this.timerOperation(this.tournamentTimerStateValue, this.tournamentTimerModeValue, this.tournamentTimerValue);
    }
  }

  updatePage() {  
    let time;
    this.tournamentTimerState == "initial" ? time = this.breakTimeValue : time  = this.tournamentTimerValue;
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
  }

  timerOperation(state, mode, time) {
    console.log('== timerOperation: ' + state + '/' + mode)
    this.tournamentTimerStateValue = state;
    this.tournamentTimerModeValue = mode;
    this.tournamentTimerValue = time;

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
        time: time,
      },
      success: function (response) {
        console.log('== timer operation response: ' + response.timer_state + ' | ' + response.timer_mode)
      }
    })
  };
}