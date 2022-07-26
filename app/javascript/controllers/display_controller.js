import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentScores: Array, // team_id, score
    tournamentId: Number,
    tournamentCompleted: Boolean,
    tournamentCurrentRoundServer: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentSet: Number,
    tournamentCurrentSetPlayers: Array,
    tournamentCurrentCourt: Number,
    breakTime: Number, 
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial"
    tournamentTimerMode: String, // "break" or "run"
  }
  static targets = [ "minute", "second", "progress", "syncing", "set", "status", "team" ]

  connect() {
    this.updatePage();
    this.autoStart();
    this.connectStatus();
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
        this.tournamentScoresValue = response.scores;
        this.tournamentCompletedValue = response.tournament_completed;
        this.tournamentTimerValue = response.timer_time;
        this.tournamentTimerModeValue = response.timer_mode;
        this.tournamentTimerStateValue = response.timer_state;
        this.tournamentCurrentSetValue = response.current_set;
        this.tournamentCurrentSetPlayersValue = response.current_set_players;
        this.tournamentCurrentRoundServerValue = response.current_round;
      }
    })
    this.updatePage();


    this.connectStatus();
    // redirect to next round or results page
    const whichCourt = document.getElementById('courts').dataset.courts
    if (this.tournamentCompletedValue == true) {
      window.location.href = "/tournaments/" + this.tournamentIdValue + "/results";
    } else if ((this.tournamentCurrentRoundServerValue != this.tournamentCurrentRoundLocalValue) && whichCourt == "single") {
      window.location.href = "/tournaments/display_single/" + this.tournamentIdValue + "/" + this.tournamentCurrentRoundServerValue + "/" + this.tournamentCurrentCourtValue
    } else if ((this.tournamentCurrentRoundServerValue != this.tournamentCurrentRoundLocalValue) && whichCourt == "double") {
      window.location.href = "/tournaments/display_multiple/" + this.tournamentIdValue + "/" + this.tournamentCurrentRoundServerValue
    }        
  }

  updatePage() {  
    // circular progress -- update progress
    if (this.tournamentTimerModeValue == "tournament") {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.tournamentTimeValue) * 100))
      this.progressTarget.style.setProperty('--value', progress)
      this.statusTarget.innerHTML = "PLAY"
    } else {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.breakTimeValue) * 100))
      this.progressTarget.style.setProperty('--value', progress)
      this.statusTarget.innerHTML = "GET READY"
    }  

    // circular progress -- update color and state
    if (this.tournamentTimerValue == 0 || this.tournamentTimerStateValue == "stop") {
      this.progressTarget.style.setProperty('--value', 100)
      this.progressTarget.classList.remove('text-accent-focus');
      this.progressTarget.classList.add('text-error');
    } else {
      this.progressTarget.classList.remove('text-error');
      this.progressTarget.classList.add('text-accent-focus');
    }

    // timer update
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
    // On initial load if connection is slow syncing... will be displayed until removed below
    document.getElementById("syncing").style.display = 'none';

    document.getElementById("current-round").innerHTML = this.tournamentCurrentRoundServerValue
    document.getElementById("current-set").innerHTML = this.tournamentCurrentSetValue

    // highlight current set row, show before and after, hide all others
    this.setTargets.forEach((element, index) => {
      if ((element.id) == (this.tournamentCurrentSetValue)) {
        element.classList.add('font-extrabold');
        element.classList.add('shadow-md');
        element.classList.remove('hidden');
      } else if (element.id == this.tournamentCurrentSetValue + 1) {
        element.classList.remove('font-extrabold');
        element.classList.remove('shadow-md');
        element.classList.remove('hidden');
      } else if (element.id == this.tournamentCurrentSetValue - 1) {
        element.classList.remove('font-extrabold');
        element.classList.remove('shadow-md');
        element.classList.remove('hidden');      
      } else {
        element.classList.add('hidden');
      }
    });

    // Update Player cards
    const team1 = this.tournamentCurrentSetPlayersValue[0];
    console.log(team1)
    // team1.forEach((element) => {
    //   console.log("-- player values -- 0 " + element)

    // }
    // const team2 = this.tournamentCurrentSetPlayersValue[1]
    // this.tournamentCurrentSetPlayersValue.forEach((element, index) => {
      // console.log("-- player values -- 0")
      // console.log(this.tournamentCurrentSetPlayersValue[0])
      // console.log("-- player values -- 1")
      // console.log(this.tournamentCurrentSetPlayersValue[1])
    // }

    // Update scores
    this.teamTargets.forEach((element, index) => {
      this.tournamentScoresValue.forEach((score, index) => {
        if (element.id == score[0]) {
          element.innerHTML = score[1];
        }
      });  
    });    
  }

  connectStatus() {
    // console.log("Current Players: ", this.tournamentCurrentSetPlayersValue);
    // console.log("Id: ", this.tournamentIdValue)
    // console.log("breakTime: ", this.breakTimeValue)
    // console.log("tournamentTime: ", this.tournamentTimeValue)
    // console.log("tournamentTimer: ", this.tournamentTimerValue)
    // console.log("tournamentTimerState: ", this.tournamentTimerStateValue)
    // console.log("tournamentTimerMode: ", this.tournamentTimerModeValue)
    // console.log("tournamentRoundServer: ", this.tournamentCurrentRoundServerValue)
    // console.log("tournamentRoundLocalValue: ", this.tournamentCurrentRoundLocalValue)
    // console.log("tournamentCurrentCourtValue: ", this.tournamentCurrentCourtValue)
  }
}