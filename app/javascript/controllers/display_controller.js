import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentScores: Array, // team_id, score
    tournamentId: Number,
    tournamentCompleted: Boolean,
    tournamentCurrentRoundServer: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentSet: Number,
    tournamentCurrentSetPlayersCourt1: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentSetPlayersCourt2: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentCourt: Number,
    breakTime: Number, 
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial"
    tournamentTimerMode: String, // "break" or "run"
  }
  static targets = [ "minute", "second", "progress", "syncing", "set", "status", "team", "step" ]

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
        this.breakTimeValue = response.break_time;
        this.tournamentScoresValue = response.scores;
        this.tournamentCompletedValue = response.tournament_completed;
        this.tournamentTimerValue = response.timer_time;
        this.tournamentTimerModeValue = response.timer_mode;
        this.tournamentTimerStateValue = response.timer_state;
        this.tournamentCurrentSetValue = response.current_set;
        this.tournamentCurrentSetPlayersCourt1Value = response.current_set_players_court1;
        this.tournamentCurrentSetPlayersCourt2Value = response.current_set_players_court2;
        this.tournamentCurrentSetPlayersLivePollValue = response.current_set_players_live_poll;
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
    // progress bar -- update progress
    if (this.tournamentTimerModeValue == "tournament") {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.tournamentTimeValue) * 100))
      this.progressTarget.style.setProperty('width', `${progress}%`)
      this.statusTarget.innerHTML = "PLAY"
    } else {
      let progress = Math.abs(Math.round((this.tournamentTimerValue / this.breakTimeValue) * 100))
      this.progressTarget.style.setProperty('width', "100%")
      this.statusTarget.innerHTML = "GET READY"
    }  

    // circular progress -- update color and state
    // if (this.tournamentTimerValue == 0 || this.tournamentTimerStateValue == "stop") {
    //   // this.progressTarget.style.setProperty('--value', 100)
    //   this.progressTarget.classList.remove('text-accent-focus');
    //   this.progressTarget.classList.add('text-error');
    // } else {
    //   this.progressTarget.classList.remove('text-error');
    //   this.progressTarget.classList.add('text-accent-focus');
    // }

    // timer update
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
    // On initial load if connection is slow syncing... will be displayed until removed below
    document.getElementById("syncing").style.display = 'none';
    // document.getElementById("current-round").innerHTML = this.tournamentCurrentRoundServerValue
    if (document.getElementById("current-round")) {
      document.getElementById("current-round").innerHTML = this.tournamentCurrentRoundServerValue
    }    

    // Update tournament steps color for current set
    this.stepTargets.forEach((element) => {
      if (element.dataset.content <= this.tournamentCurrentSetValue) {
        element.classList.add('step-primary');
      } else {
        element.classList.remove('step-primary');
      }
    });

    // Update Player cards
    let team1Data = []; 
    let team2Data = []; 
    let workData = [];
    // load correct payload depending on whether displaying court 1 or 2
    if (this.tournamentCurrentCourtValue == 1) {
      team1Data = this?.tournamentCurrentSetPlayersCourt1Value[0]
      team2Data = this?.tournamentCurrentSetPlayersCourt1Value[1]
      workData = this?.tournamentCurrentSetPlayersCourt1Value[2]
    } else if (this.tournamentCurrentCourtValue == 2) {
      team1Data = this?.tournamentCurrentSetPlayersCourt2Value[0]
      team2Data = this?.tournamentCurrentSetPlayersCourt2Value[1]
      workData = this?.tournamentCurrentSetPlayersCourt2Value[2]
    }

    let update;
    // Data Array Guide //////
    // teamXData[0][1] - element 0, player id: 0, 1 or 2 (2 is optional depending on 2 or 3 person per side config)
    // teamXData[0][1] - element 1, data: 0 - player id, 1 - player name, 2 - player initials, 3 - photo / picture url
    
    if (team1Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById('team-1-player-0-name').innerHTML = team1Data[0][1] || "loading..."
      if (team1Data[0][3] == '') {
        update = `<div id='team-1-player-0-picture' class='player-initials team-1 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team1Data[0][2] || "--"}</div>`
      } else {
        update = `<img src=${team1Data[0][3]} id='team-1-player-0-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
      }
      document.getElementById('team-1-player-0-picture').outerHTML = update

      // Team 2 Card 2
      document.getElementById('team-1-player-1-name').innerHTML = team1Data[1][1] || "loading..."
      if (team1Data[1][3] == '') {
        update = `<div id='team-1-player-1-picture' class='player-initials team-1 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team1Data[1][2] || "--"}</div>`
      } else {
        update = `<img src=${team1Data[1][3]} id='team-1-player-1-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
      }
      document.getElementById('team-1-player-1-picture').outerHTML = update

      // Team 2 Card 3
      if (team1Data[2][0] != '-' && team1Data[2].length != 0) {
        if (team1Data[2][3] == '') {
          update = `<div id='team-1-player-2-picture' class='player-initials team-1 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team1Data[2][2] || "--"}</div>`
        } else {
          update = `<img src=${team1Data[2][3]} id='team-1-player-2-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
        }
        document.getElementById('team-1-player-2-picture').outerHTML = update
        document.getElementById('team-1-player-2-name').innerHTML = team1Data[2][1] || "loading..."
      }
    }

    if (team2Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById('team-2-player-0-name').innerHTML = team2Data[0][1] || "loading..."
      if (team2Data[0][3] == '') {
        update = `<div id='team-2-player-0-picture' class='player-initials team-2 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team2Data[0][2] || "--"}</div>`
      } else {
        update = `<img src=${team2Data[0][3]} id='team-2-player-0-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
      }
      document.getElementById('team-2-player-0-picture').outerHTML = update

      // Team 2 Card 2
      document.getElementById('team-2-player-1-name').innerHTML = team2Data[1][1] || "loading..."
      if (team2Data[1][3] == '') {
        update = `<div id='team-2-player-1-picture' class='player-initials team-2 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team2Data[1][2] || "--"}</div>`
      } else {
        update = `<img src=${team2Data[1][3]} id='team-2-player-1-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
      }
      document.getElementById('team-2-player-1-picture').outerHTML = update
      
      // Team 2 Card 3
      if (team2Data[2][0] != '-' && team2Data[2].length != 0) {
        if (team2Data[2][3] == '') {
          update = `<div id='team-2-player-2-picture' class='player-initials team-2 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${team2Data[2][2] || "--"}</div>`
        } else {
          update = `<img src=${team2Data[2][3]} id='team-2-player-2-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
        }
        document.getElementById('team-2-player-2-picture').outerHTML = update
        document.getElementById('team-2-player-2-name').innerHTML = team2Data[2][1] || "loading..."
      }
    }

    if (workData[2][0] != '-') { // this prevents initial loading of null data
      document.getElementById('work-player-0').innerHTML = workData[0][1] || ""
      document.getElementById('work-player-1').innerHTML = workData[1][1] || ""
      document.getElementById('work-player-2').innerHTML = workData[2][1] || ""
    }

    // Update scores
    this.teamTargets.forEach((element) => {
      this.tournamentScoresValue.forEach((score) => {
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
    // console.log("tournamentCurrentSet: ", this.tournamentCurrentSetValue)
    // console.log("tournamentCurrentCourtValue: ", this.tournamentCurrentCourtValue)
    // console.log("tournamentScoresValue: ", this.tournamentScoresValue)
  }
}