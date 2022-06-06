import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentId: Number,
    tournamentCompleted: Boolean,
    tournamentCurrentRoundServer: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentSet: Number,
    tournamentCurrentCourt: Number,
    breakTime: Number, 
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial"
    tournamentTimerMode: String, // "break" or "run"
  }
  static targets = [ "minute", "second", "progress", "syncing", "set" ]

  connect() {
    this.connectStatus();
    this.generateTime();
    this.autoStart();
  }

  autoStart() {
    this.timer = setInterval(() => {
      this.activePolling();
    }, 1000);
  }

  activePolling() {  
    $.ajax({
      type: "GET",
      url: "/tournaments/" + this.tournamentIdValue + "/status",
      success: (response) => {
        this.tournamentCompletedValue = response.tournament_completed;
        this.tournamentTimerValue = response.timer_time;
        this.tournamentTimerModeValue = response.timer_mode;
        this.tournamentTimerStateValue = response.timer_state;
        this.tournamentCurrentSetValue = response.current_set;
        this.tournamentCurrentRoundServerValue = response.current_round;
      }
    })
    this.generateTime();

    // Highlights current set row, unhighlights others
    this.setTargets.forEach((element, index) => {
      if ((element.id) == (this.tournamentCurrentSetValue)) {
        element.classList.add('font-extrabold');
        element.classList.add('shadow-md');
      } else {
        element.classList.remove('font-extrabold');
        element.classList.remove('shadow-md');
      }    
    });
    // redirect to next round or results page
    if (this.tournamentCompletedValue == true) {
      window.location.href = "/tournaments/" + this.tournamentIdValue + "/results";
    } else if (this.tournamentCurrentRoundServerValue != this.tournamentCurrentRoundLocalValue) {
      window.location.href = "/tournaments/display_single/" + this.tournamentIdValue + "/" + this.tournamentCurrentRoundServerValue + "/" + this.tournamentCurrentCourtValue
    }              
  }

  generateTime() {  
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    if (this.tournamentTimerModeValue == "tournament") {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.tournamentTimeValue) * 100))
      this.progressTarget.style.setProperty('--value', progress)
    } else {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.breakTimeValue) * 100))
      this.progressTarget.style.setProperty('--value', progress)
    }    
    // circular progress color and zero reset to full
    if (this.tournamentTimerValue == 0 || this.tournamentTimerStateValue == "stop") {
      this.progressTarget.style.setProperty('--value', 100)
      this.progressTarget.classList.remove('text-accent-focus');
      this.progressTarget.classList.add('text-error');
    } else {
      this.progressTarget.classList.remove('text-error');
      this.progressTarget.classList.add('text-accent-focus');
    }
    // timer update
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
    document.getElementById("syncing").style.display = 'none';
  }

  connectStatus() {
    console.log("Id: ", this.tournamentIdValue)
    console.log("breakTime: ", this.breakTimeValue)
    console.log("tournamentTime: ", this.tournamentTimeValue)
    console.log("tournamentTimer: ", this.tournamentTimerValue)
    console.log("tournamentTimerState: ", this.tournamentTimerStateValue)
    console.log("tournamentTimerMode: ", this.tournamentTimerModeValue)
    console.log("tournamentRoundServer: ", this.tournamentCurrentRoundServerValue)
    console.log("tournamentRoundLocalValue: ", this.tournamentCurrentRoundLocalValue)
    console.log("tournamentCurrentCourtValue: ", this.tournamentCurrentCourtValue)
  }
}