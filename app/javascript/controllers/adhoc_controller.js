import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    sets: Number,
    rounds: Number,
    courts: Number,
    tournamentTime: { type: Number, default: 1 },
    breakTime: { type: Number, default: 0.1 },
    controllerAction: String,
    playerCount: Number,
  }

  connect() {
    this.setDefaultCourtCount(this.courtsValue);
    if (this.controllerActionValue == 'edit') {
      this.processPlayersSelected(this.playerCountValue);
      this.timeSelects();
      this.updateTournyTimeOnPage();
    }

  }

  submit() {
    document.getElementById('adhoc-form').submit();
  }
  
  formInput() {
    const playerFields = document.getElementsByClassName("player-field");
    const players = []
    if (this.controllerActionValue == 'edit') {
      this.processPlayersSelected(this.playerCountValue)
    } else {
      for (let i = 0; i < playerFields.length; i++) {
        if (playerFields[i].value.length > 0) {
          players.push(playerFields[i].value.toLowerCase())
        } 
      }
      const findDuplicates = arr => arr.filter((item, index) => arr.indexOf(item) != index)
      this.duplicateNamesNotice(findDuplicates(players).length)
      this.processPlayersSelected(players.length)
    }
    this.timeSelects();
    this.updateTournyTimeOnPage();
  }

  timeSelects() {
    this.tournamentTimeValue = document.getElementById("tournament-time").value
    this.breakTimeValue = document.getElementById("break-time").value
    this.updateTournyTimeOnPage();
  }

  updateTournyTimeOnPage() {
    const totalTourneyTime = Math.round(10 * (((this.tournamentTimeValue * this.setsValue) + ((this.setsValue - 1) * this.breakTimeValue)) * this.roundsValue) / 60) / 10
    if (this.setsValue == 0) {
      $('#tourny-time').text("Add more players!")
    } else {
      $('#tourny-time').text(totalTourneyTime + " minutes")
    }
  }   

  setDefaultCourtCount(courtsCount) {
    if (courtsCount == "1") {
      this.courtsCountOne();
    } else if (courtsCount == "2") {
      this.courtsCountTwo();
    } else if (courtsCount == "3") {
      this.courtsCountThree();
    } else {
      this.courtsCountOne();
    }
  }  

  duplicateNamesNotice(duplicateCount) {
    if (duplicateCount > 0) {
      document.getElementById("save-button").disabled = true;
      document.getElementById("save-button").classList.remove("text-indigo-700")
      document.getElementById("save-button").classList.remove("bg-indigo-100")
      document.getElementById("save-button").classList.add("text-white")
      document.getElementById("save-button").classList.add("bg-slate-100")
      document.getElementById('duplicate-notice').innerHTML = "Warning: one or more of your player names are duplicates"
    } else {
      document.getElementById("save-button").classList.remove("text-white")
      document.getElementById("save-button").classList.remove("bg-slate-100")
      document.getElementById("save-button").classList.add("text-indigo-700")
      document.getElementById("save-button").classList.add("bg-indigo-100")
      document.getElementById("save-button").disabled = false;
      document.getElementById('duplicate-notice').innerHTML = "&nbsp;"
    }
  }

  processPlayersSelected(pSelected) {
    // Limits saving and adds warning when user role is coach (needs expansion for future roles)
    // Shows courts dependent on player count selected
    switch (pSelected) {
    case 0:
      this.setsValue = 0
      this.roundsValue = 1
      this.courtsCountOne();
      break;
    case 5:
      this.setsValue = 5
      this.roundsValue = 1
      this.courtsCountOne();
      break;
    case 6:
      this.setsValue = 10
      this.roundsValue = 1
      this.courtsCountOne();
      break;
    case 7:
      this.setsValue = 7
      this.roundsValue = 1
      this.courtsCountOne();
      break;
    case 8:
    case 9:
      this.setsValue = 12
      this.roundsValue = 1
      this.courtsCountOne();
      break;
    case 10:
      this.setsValue = 5
      this.roundsValue = 2
      this.courtsCountTwo();
      break;
    case 11:
      this.setsValue = 10
      this.roundsValue = 2
      this.courtsCountTwo();
      break;
    case 12:
    case 13:
    case 14:
      this.setsValue = 7
      this.roundsValue = 2
      this.courtsCountTwo();
      break;      
    case 15:
      this.setsValue = 5
      this.roundsValue = 3
      this.courtsCountThree();
      break;
    case 16:
    case 17:
      this.setsValue = 7
      this.roundsValue = 2
      this.courtsCountTwo();
      break;    
    case 18:
    case 19:
    case 20:
    case 21:
      this.setsValue = 7
      this.roundsValue = 3
      this.courtsCountThree();
      break;      
    case 22:
    case 23:
    case 24:
      this.setsValue = 10
      this.roundsValue = 3
      this.courtsCountFour();
      break;      
    case 25:
      this.setsValue = 12
      this.roundsValue = 2
      this.courtsCountThree();
      break;
    case 26:
    case 27:
    }    
  }  

  courtsCountOne() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'none';
    document.getElementById("court-3-container").style.display = 'none';
    document.getElementById("court-4-container").style.display = 'none';
    document.getElementById("court-5-container").style.display = 'none';
    document.getElementById("court-6-container").style.display = 'none';
  };

  courtsCountTwo() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.display = 'none';
    document.getElementById("court-4-container").style.display = 'none';
    document.getElementById("court-5-container").style.display = 'none';
    document.getElementById("court-6-container").style.display = 'none';
  };

  courtsCountThree() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.display = 'block';
    document.getElementById("court-4-container").style.display = 'none';
    document.getElementById("court-5-container").style.display = 'none';
    document.getElementById("court-6-container").style.display = 'none';
  };  

  courtsCountFour() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.display = 'block';
    document.getElementById("court-4-container").style.display = 'block';
    document.getElementById("court-5-container").style.display = 'none';
    document.getElementById("court-6-container").style.display = 'none';
  };  
}