import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setDefaultCourtCount(0);
  }
  
  playerInput() {
    const playerFields = document.getElementsByClassName("player-field");
    const players = []
    for (let i = 0; i < playerFields.length; i++) {
      if (playerFields[i].value.length > 0) {
        players.push(playerFields[i].value.toLowerCase())
      } 
    }

    const findDuplicates = arr => arr.filter((item, index) => arr.indexOf(item) != index)
    this.duplicateNamesNotice(findDuplicates(players).length)
    this.processPlayersSelected(players.length)
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
      document.getElementById('duplicate-notice').innerHTML = "Warning: one or more of your player names are duplicates"
    } else {
      document.getElementById('duplicate-notice').innerHTML = "&nbsp;"
    }
  }

  processPlayersSelected(pSelected) {
    // Limits saving and adds warning when user role is coach (needs expansion for future roles)
    const userIsCoach = "<%= current_user.has_role?(:coach) %>"
    // Shows courts dependent on player count selected
    switch (pSelected) {
    case 0:
      localStorage['tournamentSets'] = 0
      localStorage['tournamentRounds'] = 1
      this.courtsCountOne();
      break;
    case 6:
      localStorage['tournamentSets'] = 10
      localStorage['tournamentRounds'] = 1
      this.courtsCountOne();
      break;
    case 7:
      localStorage['tournamentSets'] = 7
      localStorage['tournamentRounds'] = 1
      this.courtsCountOne();
      break;
    case 8:
    case 9:
      localStorage['tournamentSets'] = 12
      localStorage['tournamentRounds'] = 1
      this.courtsCountOne();
      break;
    case 10:
      localStorage['tournamentSets'] = 5
      localStorage['tournamentRounds'] = 2
      this.courtsCountTwo();
      break;
    case 11:
      localStorage['tournamentSets'] = 10
      localStorage['tournamentRounds'] = 2
      this.courtsCountTwo();
      break;
    case 12:
    case 13:
    case 14:
      localStorage['tournamentSets'] = 7
      localStorage['tournamentRounds'] = 2
      this.courtsCountTwo();
      break;      
    case 15:
      localStorage['tournamentSets'] = 5
      localStorage['tournamentRounds'] = 3
      this.courtsCountThree();
      break;
    case 16:
    case 17:
      localStorage['tournamentSets'] = 7
      localStorage['tournamentRounds'] = 2
      this.courtsCountTwo();
      break;    
    case 18:
    case 19:
    case 20:
    case 21:
      localStorage['tournamentSets'] = 7
      localStorage['tournamentRounds'] = 3
      this.courtsCountThree();
      break;      
    case 22:
    case 23:
    case 24:
      localStorage['tournamentSets'] = 10
      localStorage['tournamentRounds'] = 3
      this.courtsCountFour();
      break;      
    case 25:
      localStorage['tournamentSets'] = 12
      localStorage['tournamentRounds'] = 2
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