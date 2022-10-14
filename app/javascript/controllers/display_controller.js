import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    submitButtonText: { type: String, default: 'Smurf' },
    allScoresEntered: { type: Boolean, default: false },
    tournamentScores: Array, // team_id, score
    tournamentId: Number,
    tournamentCompleted: Boolean,
    tournamentCurrentSetPlayersCourt1: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentSetPlayersCourt2: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentRound: Number,
    tournamentCurrentCourt: Number,
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial"
    tournamentMatchesPerRound: Number,
    tournamentCurrentCourtMatch: Number,
    modalPurpose: String,
    modalMessageText: { type: String, default: 'Smurf' },
  }
  static targets = [ "minute", "second", "progress", "progressbackground", "syncing", "modal", "modalMessage", "modalButtons", "flash", "flashMessage",
    "set", "status", "team", "step", "spinner", "team1Score", "team2Score", "submitClick", "match"
  ]

  connect() {
    this.updatePage();
    console.log('--> allScoresEntered: ' + this.allScoresEnteredValue)
    // this.autoStart();
  }

  submitClick() {
    console.log("--> submitClick")
    console.log('--> allScoresEntered: ' + this.allScoresEnteredValue)
    if (this.allScoresEnteredValue != true) {
      this.modalPurposeValue = "submit-scores"
      this.openModal();
    } else {
      this.modalPurposeValue = "submit-round"
      this.openModal();
    }    
  }

  openModal() {
    console.log("open modal")
    if (this.modalPurposeValue == "submit-scores") {
      this.modalButtonsTarget.style.display = 'flex';
      this.modalMessageTarget.innerHTML = `Submit scores for Match #${this.tournamentCurrentCourtMatchValue}?`
    } else if (this.modalPurposeValue == "submit-round") {
      this.modalButtonsTarget.style.display = 'flex';
      this.modalMessageTarget.innerHTML = 'Submit Round? (Warning: this can NOT be undone)'
    } else if (this.modalPurposeValue == "message") {
      this.modalButtonsTarget.style.display = 'none';
      this.confirmationMessageValue = 'Message'
    }
    this.modalTarget.classList.add('modal-open');
  }

  modalConfirmClick() {
    this.modalTarget.classList.remove('modal-open');
    this.updateSubmitButton('submitting')
    this.submitScores();

    setTimeout(() => {
      this.modalTarget.classList.remove('modal-open');
    }, 5000);
  }

  modalCancelClick() {
    this.modalTarget.classList.remove('modal-open');
  }

  submitScores() {
    $.ajax({
      type: "POST",
      url: "/tournaments/submit_scores",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
        function: this.allScoresEnteredValue ? 'round' : 'scores',
        current_court_match: this.tournamentCurrentCourtMatchValue,
        court: this.tournamentCurrentCourtValue,
        round: this.tournamentCurrentRoundValue,
        scores: { team1: this.team1ScoreTarget.value, team2: this.team2ScoreTarget.value }
      },
      success: (response) => {
        this.allScoresEnteredValue = response.all_scores_entered;
        this.tournamentScoresValue = response.scores;
        this.tournamentCompletedValue = response.tournament_completed;
        this.tournamentCurrentSetPlayersCourt1Value = response.current_set_players_court1;
        this.tournamentCurrentSetPlayersCourt2Value = response.current_set_players_court2;
        this.tournamentCurrentSetPlayersLivePollValue = response.current_set_players_live_poll;
        this.tournamentCurrentRoundValue = response.current_round;
        this.tournamentCurrentCourtMatchValue = response.current_court_match;
        this.submitClickTarget.innerHTML = this.submitButtonTextValue;
        this.updatePage(); 
        console.log('--> submitScores')
        console.log('message: ' + response.message)
        console.log('status: ' + response.status)
        if (response.status == 'new-round') { // reload page if round processed
          window.location.href = "/tournaments/display/" + this.tournamentIdValue + "/" + this.tournamentCurrentCourtValue
          this.modalPurposeValue = "message"
          this.modalMessageTarget.innerHTML = response.message
          this.openModal();
        } else if (response.message.length != 0) {
          this.modalPurposeValue = "message"
          this.modalMessageTarget.innerHTML = response.message
          this.openModal();
        }       
      }
    })
  }

  updatePage() {  
    this.fetchNewData(); 
    this.updateProgressBar();
    this.updateTimerDigits();
    this.updateStepBar();
    this.updatePlayerCards();
    this.updateMatchScoringTable();
    this.updateMatchLabel();
    this.updateSubmitButton('update');
  }




  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////-----------------------------/ update page methods /--------------------------------------------------------------------//////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  updateSubmitButton(button_status) {
    if (button_status == 'submitting') {
      const submitLoadingText = 'Submitting...&nbsp;<svg role="status" class="inline mr-3 w-6 h-6 text-white animate-spin" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="#AAA"/><path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentColor"/></svg>'
      this.submitClickTarget.innerHTML = submitLoadingText
    } else {
      if (this.allScoresEnteredValue == true) {
        this.submitClickTarget.innerHTML = 'Submit Round';
        this.team1ScoreTarget.disabled = true;
        this.team2ScoreTarget.disabled = true;
      } else {
        this.submitClickTarget.innerHTML = 'Submit Scores';
      }
    }
  }
  
  fetchNewData() {
    const current_time = Math.floor(Date.now() / 1000) // last_update on server
    $.ajax({
      type: "GET",
      url: `/tournaments/status/${this.tournamentIdValue}/${this.tournamentCurrentCourtValue}/${current_time}`,
      success: (response) => {
        this.tournamentScoresValue = response.scores;
        this.tournamentCompletedValue = response.tournament_completed;
        this.tournamentCurrentSetPlayersCourt1Value = response.current_set_players_court1;
        this.tournamentCurrentSetPlayersCourt2Value = response.current_set_players_court2;
        this.tournamentCurrentRoundValue = response.current_round;
        this.tournamentCurrentCourtMatchValue = response.current_court_match;

        this.updateMatchLabel();
      }
    })
  }

  updateProgressBar() {
    // progress bar -- update progress
    const totalMatchTime = this.breakTimeValue + this.tournamentTimeValue
    let progress = Math.abs(Math.round((this.tournamentTimerValue / totalMatchTime) * 100))
    this.progressTarget.style.setProperty('width', `${progress}%`)
    if (this.tournamentAdminViewsValue == 0) { // when all admin windows closed
      this.progressTarget.style.setProperty('width', "100%")
      this.statusTarget.innerHTML = "GET READY"
    } else if (this.tournamentTimerValue <= this.tournamentTimeValue && this.tournamentTimerStateValue == "run") { // break time
      this.statusTarget.innerHTML = "PLAY"
    } else {
      this.statusTarget.innerHTML = "GET READY"
    }  
    // progress bar -- update color and state
    if (this.tournamentAdminViewsValue == 0) { // when all admin windows closed
      this.progressTarget.classList.remove('bg-green-500');
      this.progressTarget.classList.add('bg-yellow-500');
      this.progressbackgroundTarget.classList.remove('bg-green-200');
      this.progressbackgroundTarget.classList.add('bg-yellow-200');
    } else if (this.tournamentTimerValue <= this.tournamentTimeValue && this.tournamentTimerStateValue == "run") {
      this.progressTarget.classList.remove('bg-yellow-500');
      this.progressTarget.classList.add('bg-green-500');
      this.progressbackgroundTarget.classList.remove('bg-yellow-200');
      this.progressbackgroundTarget.classList.add('bg-green-200');
    } else {
      this.progressTarget.classList.remove('bg-green-500');
      this.progressTarget.classList.add('bg-yellow-500');
      this.progressbackgroundTarget.classList.remove('bg-green-200');
      this.progressbackgroundTarget.classList.add('bg-yellow-200');
    }
    // timer running spinner
    if (this.tournamentAdminViewsValue == 0) { // when all admin windows closed
      this.spinnerTarget.style.display = 'none';
    } else if (this.tournamentTimerStateValue == "run") {
      this.spinnerTarget.style.display = 'inline-block';
    } else {
      this.spinnerTarget.style.display = 'none';
    }    
  }

  updateTimerDigits() {
    // timer digits update
    let second = this.tournamentTimerValue % 60;
    let minute = Math.floor(this.tournamentTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
    // On initial load if connection is slow syncing... will be displayed until removed below
    document.getElementById("syncing").style.display = 'none';
    document.getElementById("current-round").innerHTML = this.tournamentCurrentRoundValue    
  }

  updateStepBar() {
    // step bar -- update for current set
    this.stepTargets.forEach((element) => {
      if (element.dataset.content <= this.tournamentCurrentCourtMatchValue) {
        element.classList.add('step-primary')
      } else {
        element.classList.remove('step-primary');
      }
    });    
  }

  updatePlayerCards() {
    // update Player cards
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
    // player cards
    let update;
    // Data Array Guide //////
    // teamXData[0][1] - element 0, player id: 0, 1 or 2 (2 is optional depending on 2 or 3 person per side config)
    // teamXData[0][1] - element 1, data: 0 - player id, 1 - player name, 2 - player initials, 3 - photo / picture url

    if (team1Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById('team-1-player-0-name').innerHTML = team1Data[0][1] || "loading..."
      if (team1Data[0][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(1, 0, team1Data[0][2])
      } else {
        update = this.photoDiv(1, 0, team1Data[0][3])
      }
      document.getElementById('team-1-player-0-picture').outerHTML = update

      // Team 2 Card 2
      document.getElementById('team-1-player-1-name').innerHTML = team1Data[1][1] || "loading..."
      if (team1Data[1][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(1, 1, team1Data[1][2])
      } else {
        update = this.photoDiv(1, 1, team1Data[1][3])
      }      
      document.getElementById('team-1-player-1-picture').outerHTML = update
      
      // Team 2 Card 3
      if (team1Data[2][0] != '-' && team1Data[2].length != 0) {
        if (team1Data[2][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
          update = this.initialsDiv(1, 2, team1Data[2][2])
        } else {
          update = this.photoDiv(1, 2, team1Data[2][3])
        }
        document.getElementById('team-1-player-2-picture').outerHTML = update
        document.getElementById('team-1-player-2-name').innerHTML = team1Data[2][1] || "loading..."
      }
    }

    if (team2Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById('team-2-player-0-name').innerHTML = team2Data[0][1] || "loading..."
      if (team2Data[0][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(2, 0, team2Data[0][2])
      } else {
        update = this.photoDiv(2, 0, team2Data[0][3])
      }
      document.getElementById('team-2-player-0-picture').outerHTML = update

      // Team 2 Card 2
      document.getElementById('team-2-player-1-name').innerHTML = team2Data[1][1] || "loading..."
      if (team2Data[1][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(2, 1, team2Data[1][2])
      } else {
        update = this.photoDiv(2, 1, team2Data[1][3])
      }
      document.getElementById('team-2-player-1-picture').outerHTML = update
      
      // Team 2 Card 3
      if (team2Data[2][0] != '-' && team2Data[2].length != 0) {
        if (team2Data[2][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
          update = this.initialsDiv(2, 2, team2Data[2][2])
        } else {
          update = this.photoDiv(2, 2, team2Data[2][3])
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
  }

  updateMatchScoringTable() {
    // match and scoring table
    this.teamTargets.forEach((element) => {
      this.tournamentScoresValue.forEach((score) => {
        if (element.id == score[0]) {
          element.innerHTML = score[1];
        }
      });  
    });       
  }

  updateMatchLabel() {
    this.matchTarget.innerHTML = `Match #${this.tournamentCurrentCourtMatchValue}`
  }

  initialsDiv(team, player, data) {
    // HTML to render initials card
    return `<div id='team-${team}-player-${player}-picture' class='player-initials team-2 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${data || "--"}</div>`
  }

  photoDiv(team, player, data) {
    // HTML to render photo on card
    return `<img src=${data} id='team-${team}-player-${player}-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
  }






  /////////////// Deprecated
  autoStart() {
    this.timer = setInterval(() => {
      this.activePolling();
    }, 3000);
  }

  // Modal functionality

  dismiss() {
    this.element.remove();
  }
} 