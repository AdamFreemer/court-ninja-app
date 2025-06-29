import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    courtTab: { type: Number, default: 1 },
    timerMode: { type: Boolean, default: false },
    isNew: Boolean, 
    submitButtonText: String,
    allScoresEntered: { type: Boolean, default: false },
    tournamentScores: Array, // team_id, score
    tournamentId: Number,
    isCompleted: Boolean,
    tournamentCurrentSetPlayersCourt1: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentSetPlayersCourt2: { type: Array, default: [[['-'], ['-'],['-']], [['-'], ['-'],['-']],[['-'], ['-'],['-']]] },
    tournamentCurrentRound: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentCourt: Number,
    tournamentMatchesPerRound: Number,
    tournamentCurrentCourtMatch: Number,
    tournamentTotalRounds: Number,
    courts: Number,
    currentMatch: Number,
    matchTime: Number, // static value for Tournament Time
    matchPreTime: Number, // static value for Tournament Pre Time
    matchTimer: Number, // Actual countdown timer value
    modalPurpose: String,
    modalMessageText: { type: String, default: 'Smurf' },
    matchRowSelected: Number,
  }
  static targets = [ "timerSection", "displayModeIcon", "timerModeToggle", "displayCards", "displayCardsDisplayMode", "minute", "second", "progress", "progressbackground", "modal", "timerSection", "modalMessage", "modalButtons", "flash", "flashMessage", "playButton", "pauseButton", "primaryCourtLabel", "spinner", "set", "status", "team", "step", 
  "Court1Team1Score", "Court1Team2Score", "Court2Team1Score", "Court2Team2Score", "Court3Team1Score", "Court3Team2Score", "Court4Team1Score", "Court4Team2Score", 
  "team1ScoreUpdate", "team2ScoreUpdate", "mainPageSubmitText", "currentMatch", "matchSelected", "matchRowSelected", "resultsTables", "matchProgressBar"
  ]

  connect() {
    console.log("-- display controller connect")
    this.updatePage();
    this.pauseButtonTarget.style.display = 'none'
    this.playButtonTarget.style.display = 'inline-block'
    this.spinnerTarget.style.display = 'none'

    this.isNew();
    this.displayCardsDisplayModeTarget.style.display = "none"
  }

  // modal related methods ////////////////////////////////////////////////////////////////

  submitScoresClick() {
    console.log("clicks button")
    if (this.allScoresEnteredValue != true) {
      this.modalPurposeValue = "submit-scores"
      this.openModal();
    } else {
      this.modalPurposeValue = "submit-round"
      this.openModal();
    }
  }

  drawerSubmitScoresClick() {
    if (this.matchRowSelectedValue && this.team1ScoreUpdateTarget.value.length != 0 && this.team2ScoreUpdateTarget.value.length != 0) {
      this.modalPurposeValue = "update-scores"
      this.modalMessageTarget.innerHTML = `<p>Are you sure you want to update scores for </p> Match #${this.matchRowSelectedValue}?`
      this.openModal();
    } else {
      this.modalPurposeValue = "message"
      this.modalMessageTarget.innerHTML = "Alert: Match to update must be selected and scores for both Teams to Submit."
      this.openModal();
    }
  }

  openModal() {
    this.reset();
    if (this.displayModeValue) return false 

    if (this.modalPurposeValue == "submit-scores") {
        this.modalButtonsTarget.style.display = 'flex';
        this.modalMessageTarget.innerHTML = `Submit scores for Match #${this.currentMatchValue}?`
    } else if (this.modalPurposeValue == "submit-round") {
        this.modalButtonsTarget.style.display = 'flex';
        this.modalMessageTarget.innerHTML = 'Submit Round? (Warning: this can NOT be undone)'
    } else if (this.modalPurposeValue == "message") {
        this.modalButtonsTarget.style.display = 'none';
        this.confirmationMessageValue = 'Message'
    } else if (this.modalPurposeValue == "update-scores") {
        this.modalButtonsTarget.style.display = 'flex';
        this.confirmationMessageValue = 'Message'
    } else if (this.modalPurposeValue == "is-new") {
      return false
      // this.modalButtonsTarget.style.display = 'flex';
      // this.modalMessageTarget.innerHTML = 'Click Confirm to start the first match!'
    }
    this.modalTarget.classList.add('modal-open');
  }

  modalCancelClick() {
    this.modalTarget.classList.remove('modal-open');
  }

  // The actual score submission is triggered from the confirmation button on the confirm modal.
  modalConfirmClick() {
    this.modalTarget.classList.remove('modal-open');

    // new tournament
    if (this.modalPurposeValue == "is-new") {
      this.reset();
    }    
    // submit (update) scores from drawer
    if (this.modalPurposeValue == "update-scores") {
      this.updateScores();
      this.reset();
    } 
    // submit (scores / round) from main page
    if (this.modalPurposeValue == "submit-scores" || this.modalPurposeValue == "submit-round") {
      this.submitScores();
      this.reset();
    }
    setTimeout(() => {
      this.modalTarget.classList.remove('modal-open');
    }, 5000);
  }

  ///////////////////////////////////////////////////////////////////////////////////


  // drawer service methods  /////////////////////////////////////////////////////////////////

  matchSelectClick(event) {
    let inputSelected;
    if (event.target.type == "radio") { // this is when the actual radio button is clicked
      inputSelected = event.target.parentElement.children[0]
    } else { // this is when something on the row but not the radio button is clicked
      inputSelected = event.target.parentElement.children[0].children[0]
    }
    this.matchSelectedTargets.forEach((element) => {
      this.matchRowSelectedValue = inputSelected.id
      if (element.id == inputSelected.id) {
        element.parentElement.parentElement.children[0].children[0].checked = true
        element.parentElement.parentElement.classList.add('font-extrabold');
      } else {
        element.parentElement.parentElement.children[0].children[0].checked = false
        element.parentElement.parentElement.classList.remove('font-extrabold');
      }
    });
  }

  backToTournamentsClick() {
    event.preventDefault();
    // window.location.href = "/leaderboard"
    console.log("##### Hello")
  }

  editTournamentClick() {
    window.location.href = `/tournaments/${this.tournamentIdValue}/edit`
  }

  openCourtOneClick() {
    window.open(`/tournaments/display/${this.tournamentIdValue}/1`, '_blank');
  }

  openCourtTwoClick() {
    window.open(`/tournaments/display/${this.tournamentIdValue}/2`, '_blank');
  }

  // display mode /////////////////////////////////////////////////////////////////

  timerModeToggleClick() {
    if (this.timerModeToggleTarget.checked) {
      this.timerModeValue = true;
      this.timerSectionTarget.style.display = 'inline';
    } else {
      this.timerModeValue = false;
      this.timerSectionTarget.style.display = 'none';
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////

  // timer controls /////////////////////////////////////////////////////////////////

  playPauseClick() {
    if (this.pauseButtonTarget.style.display == 'none') {
      this.start();
    } else {
      this.pause();
    }
  }

  start() {
    if (this.matchTimerValue > 0) {
      this.timerRun();
      this.pauseButtonTarget.style.display = 'inline-block'
      this.playButtonTarget.style.display = 'none'
      this.spinnerTarget.style.display = 'inline-block'
    }
  }

  pause() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    this.pauseButtonTarget.style.display = 'none'
    this.playButtonTarget.style.display = 'inline-block'
    this.spinnerTarget.style.display = 'none'
  }

  reset() {
    clearInterval(this.timer);
    this.matchTimerValue = this.matchTimeValue
    this.pauseButtonTarget.style.display = 'none'
    this.playButtonTarget.style.display = 'inline-block'
    this.spinnerTarget.style.display = 'none'
    this.updateProgressBar();
    this.updateTimerDigits();
  }

  timerRun() {
    this.timer = setInterval(() => {
      this.timerDecrement();
    }, 1000);
  }

  timerDecrement() {
    this.matchTimerValue--

    if (this.matchTimerValue <= 0) {
      clearInterval(this.timer);
      this.pauseButtonTarget.style.display = 'none'
      this.playButtonTarget.style.display = 'inline-block'
      this.spinnerTarget.style.display = 'none'
      this.matchTimerValue = this.matchTimeValue
    } else {

    }
    this.updateProgressBar();
    this.updateTimerDigits();
  }

  courtTabOneClick() {
    this.courtTabValue = 1
    console.log('courtTab: ' + this.courtTabValue)
  }

  courtTabTwoClick() {
    this.courtTabValue = 2
    console.log('courtTab: ' + this.courtTabValue)
  }

  ///////////////////////////////////////////////////////////////////////////////////


  // service methods ////////////////////////////////////////////////////////////////

  submitScores() {
    let scores = { 
      court1: { team1: this.Court1Team1ScoreTarget.value, team2: this.Court1Team2ScoreTarget.value },
      court2: { team1: this.Court2Team1ScoreTarget.value, team2: this.Court2Team2ScoreTarget.value },
      court3: { team1: this.Court3Team1ScoreTarget.value, team2: this.Court3Team2ScoreTarget.value },
      court4: { team1: this.Court4Team1ScoreTarget.value, team2: this.Court4Team2ScoreTarget.value }
    }

    $.ajax({
      type: "POST",
      url: "/tournaments/submit_scores",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
        function: this.allScoresEnteredValue ? 'round' : 'scores',
        round: this.tournamentCurrentRoundValue,
        scores: scores,
        // to deprecate
        current_match: this.currentMatchValue
      },
      success: (response) => {
        this.isCompletedValue = response.is_completed;
        this.allScoresEnteredValue = response.all_scores_entered;
        this.tournamentScoresValue = response.scores;
        this.tournamentCurrentSetPlayersCourt1Value = response.current_set_players_court1;
        this.tournamentCurrentSetPlayersCourt2Value = response.current_set_players_court2;
        this.tournamentCurrentSetPlayersLivePollValue = response.current_set_players_live_poll;
        this.tournamentCurrentRoundValue = response.current_round;
        this.currentMatchValue = response.current_match;
        this.mainPageSubmitTextTarget.innerHTML = this.submitButtonTextValue;
        this.updatePage(); 
        if (response.status == 'tournament-completed') { // reload page if round processed
          window.location.href = "/tournaments/" + this.tournamentIdValue + "/results" 
          this.modalPurposeValue = "message"
        } else if (response.message.length != 0) {
          this.modalPurposeValue = "message"
          this.modalMessageTarget.innerHTML = response.message
          this.openModal();
        }       
      }
    })
  }

  updateScores() {
    let scores = { team1: this.team1ScoreUpdateTarget.value, team2: this.team2ScoreUpdateTarget.value }
    $.ajax({
      type: "POST",
      url: "/tournaments/update_scores",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
        court: this.courtTabValue,
        selected_match: this.matchRowSelectedValue,
        scores: scores
      },
      success: (response) => {
        window.location.href = "/tournaments/display/" + this.tournamentIdValue + "/" + this.tournamentCurrentCourtValue
        this.modalPurposeValue = "message"
        this.modalMessageTarget.innerHTML = response.message
        this.openModal();
      }
    })
  }

  fetchNewData() {
    const current_time = Math.floor(Date.now() / 1000) // last_update on server
    $.ajax({
      type: "GET",
      url: `/tournaments/status/${this.tournamentIdValue}/${this.tournamentCurrentCourtValue}/${current_time}`,
      success: (response) => {
        this.isNewValue = response.is_new;
        this.courtsValue = response.courts;
        this.currentMatchValue = response.match;
        this.tournamentScoresValue = response.scores;
        this.isCompletedValue = response.is_completed;
        this.tournamentCurrentSetPlayersCourt1Value = response.current_set_players_court1;
        this.tournamentCurrentSetPlayersCourt2Value = response.current_set_players_court2;
        this.tournamentCurrentRoundValue = response.current_round;
        this.currentMatchValue = response.current_match;

        this.updateMatchLabel();
        this.isNew();
        console.log(response)
      }
    })
  }

  isNew() {
    
    if (this.currentMatchValue == 1) {
      this.modalPurposeValue = "is-new"      
      this.openModal();
      if (this.courtsValue == 2 && this.isNewValue == true) {
        window.open(`/tournaments/display/${this.tournamentIdValue}/1`, '_blank');
        this.setStale();
      }
    }
  };

  setStale() {
    $.ajax({
      type: "POST",
      url: "/tournaments/set_stale",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
      },
      success: (response) => {

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
    this.updateSubmitButton('update'); // default 'update' page argument

    this.timerModeToggleClick() // set timer to default hidden / off

    this.Court1Team1ScoreTarget.value = 0
    this.Court1Team2ScoreTarget.value = 0
    this.Court2Team1ScoreTarget.value = 0
    this.Court2Team2ScoreTarget.value = 0
    this.Court3Team1ScoreTarget.value = 0
    this.Court3Team2ScoreTarget.value = 0
    this.Court4Team1ScoreTarget.value = 0
    this.Court4Team2ScoreTarget.value = 0
    this.matchRowSelectedValue = null // drawer match selection
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////-----------------------------/ update page methods /--------------------------------------------------------------------//////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  updateSubmitButton(button_status) {
    if (button_status == 'submitting') {
      const submitLoadingText = 'Submitting...&nbsp;<svg role="status" class="inline mr-3 w-6 h-6 text-white animate-spin" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="#AAA"/><path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentColor"/></svg>'
      this.mainPageSubmitTextTarget.innerHTML = submitLoadingText
    } else if (this.allScoresEnteredValue == true) {
      this.mainPageSubmitTextTarget.innerHTML = 'Submit Tournament';
      this.mainPageSubmitTextTarget.classList.add('bg-red-500');
      this.mainPageSubmitTextTarget.classList.remove('bg-blue-700');
      this.Court1Team1ScoreTarget.disabled = true;
      this.Court1Team2ScoreTarget.disabled = true;
      this.Court2Team1ScoreTarget.disabled = true;
      this.Court2Team2ScoreTarget.disabled = true;
      this.Court3Team1ScoreTarget.disabled = true;
      this.Court3Team2ScoreTarget.disabled = true;
      this.Court4Team1ScoreTarget.disabled = true;
      this.Court4Team2ScoreTarget.disabled = true;   
    } else if (this.allScoresEnteredValue == false) {
      this.Court1Team1ScoreTarget.disabled = false;
      this.Court1Team2ScoreTarget.disabled = false;
      this.Court2Team1ScoreTarget.disabled = false;
      this.Court2Team2ScoreTarget.disabled = false;
      this.Court3Team1ScoreTarget.disabled = false;
      this.Court3Team2ScoreTarget.disabled = false;
      this.Court4Team1ScoreTarget.disabled = false;
      this.Court4Team2ScoreTarget.disabled = false
      this.mainPageSubmitTextTarget.innerHTML = 'Submit Scores';
      this.modalPurposeValue = "submit-scores";
    } 
  }

  updateProgressBar() {
    // progress bar -- update color and state -- update state message
    let progress = Math.abs(Math.round((this.matchTimerValue / this.matchTimeValue) * 100))
    this.progressTarget.style.setProperty('width', `${progress}%`)

    if (this.matchTimerValue < (this.matchTimeValue - this.matchPreTimeValue)) {
      this.statusTarget.innerHTML = "PLAY"
      this.progressTarget.classList.remove('bg-red-400');
      this.progressTarget.classList.add('bg-green-500');
      this.progressbackgroundTarget.classList.remove('bg-red-200');
      this.progressbackgroundTarget.classList.add('bg-green-200');
    } else {
      this.statusTarget.innerHTML = "GET READY"
      this.progressTarget.classList.remove('bg-green-500');
      this.progressTarget.classList.add('bg-red-400');
      this.progressbackgroundTarget.classList.remove('bg-green-200');
      this.progressbackgroundTarget.classList.add('bg-red-200');
    }   
  }

  updateTimerDigits() {
    // timer digits update
    let second = this.matchTimerValue % 60;
    let minute = Math.floor(this.matchTimerValue / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second

    if (this.tournamentTotalRoundsValue > 1) {
      document.getElementById("current-round").innerHTML = this.tournamentCurrentRoundValue  
    }
  }

  updateStepBar() {
    // step bar -- update for current set
    // (@tournament.current_matches[@court_number.to_s] + (steps / 2))
    console.log('-- updateStepBar -- currentMatchValue: ' + this.currentMatchValue + '| this.tournamentMatchesPerRoundValue: ' + this.tournamentMatchesPerRoundValue + '| this.tournamentCurrentRoundValue: ' + this.tournamentCurrentRoundValue)


    
    const currentCourtMatch = this.currentMatchValue + (this.tournamentMatchesPerRoundValue * (this.tournamentCurrentRoundValue - 1))
    this.stepTargets.forEach((element) => {
      if (element.dataset.content <= currentCourtMatch) {
        element.classList.add('step-primary')
      } else {
        element.classList.remove('step-primary');
      }
    });    
  }

  updatePlayerCards() {
    // player cards

    let team1Data = []; 
    let team2Data = []; 
    let workData = [];
    // Data Array Guide //////
    // teamXData[0][1] - element 0, player id: 0, 1 or 2 (2 is optional depending on 2 or 3 person per side config)
    // teamXData[0][1] - element 1, data: 0 - player id, 1 - player name, 2 - player initials, 3 - photo / picture url
    team1Data = this?.tournamentCurrentSetPlayersCourt1Value[0]
    team2Data = this?.tournamentCurrentSetPlayersCourt1Value[1]
    workData = this?.tournamentCurrentSetPlayersCourt1Value[2]
    // Court: 1, team1Data, team2Data, workData
    this.updateCourt(1, team1Data, team2Data, workData);

    if (this.courtsValue > 1) {
      team1Data = this?.tournamentCurrentSetPlayersCourt2Value[0]
      team2Data = this?.tournamentCurrentSetPlayersCourt2Value[1]
      workData = this?.tournamentCurrentSetPlayersCourt2Value[2]      
      // Court: 2, team1Data, team2Data, workData
      this.updateCourt(2, team1Data, team2Data, workData);
    }
  }  

  updateCourt(court, team1Data, team2Data, workData) {
    console.log("----- updateCourt, court: " + court)
    let update;
    if (team1Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById(`court-${court}-team-1-player-0-name`).innerHTML = team1Data[0][1] || "loading..."
      if (team1Data[0][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(court, 1, 0, team1Data[0][2])
      } else {
        update = this.photoDiv(court, 1, 0, team1Data[0][3])
      }
      document.getElementById(`court-${court}-team-1-player-0-picture`).outerHTML = update

      // Team 2 Card 2
      document.getElementById(`court-${court}-team-1-player-1-name`).innerHTML = team1Data[1][1] || "loading..."
      if (team1Data[1][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(court, 1, 1, team1Data[1][2])
      } else {
        update = this.photoDiv(court, 1, 1, team1Data[1][3])
      }      
      document.getElementById(`court-${court}-team-1-player-1-picture`).outerHTML = update
      
      // Team 2 Card 3
      if (team1Data[2][0] != '-' && team1Data[2].length != 0) {
        if (team1Data[2][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
          update = this.initialsDiv(court, 1, 2, team1Data[2][2])
        } else {
          update = this.photoDiv(court, 1, 2, team1Data[2][3])
        }
        document.getElementById(`court-${court}-team-1-player-2-picture`).outerHTML = update
        document.getElementById(`court-${court}-team-1-player-2-name`).innerHTML = team1Data[2][1] || "loading..."
      }
    }

    if (team2Data[2][0] != '-') { // this prevents initial loading of null data
      // Team 2 Card 1
      document.getElementById(`court-${court}-team-2-player-0-name`).innerHTML = team2Data[0][1] || "loading..."
      if (team2Data[0][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(court, 2, 0, team2Data[0][2])
      } else {
        update = this.photoDiv(court, 2, 0, team2Data[0][3])
      }
      document.getElementById(`court-${court}-team-2-player-0-picture`).outerHTML = update

      // Team 2 Card 2
      document.getElementById(`court-${court}-team-2-player-1-name`).innerHTML = team2Data[1][1] || "loading..."
      if (team2Data[1][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
        update = this.initialsDiv(court, 2, 1, team2Data[1][2])
      } else {
        update = this.photoDiv(court, 2, 1, team2Data[1][3])
      }
      document.getElementById(`court-${court}-team-2-player-1-picture`).outerHTML = update
      
      // Team 2 Card 3
      if (team2Data[2][0] != '-' && team2Data[2].length != 0) {
        if (team2Data[2][3] == '' || typeof(team1Data[0][3]) == 'undefined') {
          update = this.initialsDiv(court, 2, 2, team2Data[2][2])
        } else {
          update = this.photoDiv(court, 2, 2, team2Data[2][3])
        }
        document.getElementById(`court-${court}-team-2-player-2-picture`).outerHTML = update
        document.getElementById(`court-${court}-team-2-player-2-name`).innerHTML = team2Data[2][1] || "loading..."
      }
    }

    if (workData[2][0] != '-') { // this prevents initial loading of null data
      document.getElementById(`court-${court}-work-player-0`).innerHTML = workData[0][1] || ""
      document.getElementById(`court-${court}-work-player-1`).innerHTML = workData[1][1] || ""
      document.getElementById(`court-${court}-work-player-2`).innerHTML = workData[2][1] || ""
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
    const match = this.currentMatchValue
    this.currentMatchTarget.innerHTML = `Match #${match}`
    this.matchProgressBarTarget.innerHTML = `Match #${match}`
  }

  initialsDiv(court, team, player, data) {
    console.log("----- initialsDiv, court: " + court)
    // HTML to render initials card
    return `<div id='court-${court}-team-${team}-player-${player}-picture' class='player-initials team-2 w-2/3 h-2/3 mx-auto aspect-square bg-gray-300 rounded-[50%] flex justify-center items-center text-3xl border-gray-600 text-gray-600'>${data || "--"}</div>`
  }

  photoDiv(court, team, player, data) {
    // HTML to render photo on card
    return `<img src=${data} id='court-${court}-team-${team}-player-${player}-picture' class='rounded-[50%] top-0 bottom-0 left-0 right-0 w-full h-full object-cover object-center'>`
  }

  // Modal functionality

  dismiss() {
    this.element.remove();
  }
} 