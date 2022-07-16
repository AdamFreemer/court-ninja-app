import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
  }
  
  static targets = [
    "input",
    "player1",
    "player2",
    "player3",
    "player4",
    "player5",
    "player6",
    "player7",
    "player8",
    "player9",
    "player10",
    "player11",
    "player12",
    "player13",
    "player14"
  ]

  connect() {
    this.setDefaultCourtCount();
  }
  
  playerInput() {
    let players = 0;
    const playerFields = document.getElementsByClassName('player-field')
    console.log(playerFields)
    playerFields.each(function() {
      console.log("playerField: " + this)
      //  if ($(this).val() != "") {
      //    players++
      //  }
    });    
    console.log("--- players: " + players)
    this.processPlayersSelected(players)
  }

  setDefaultCourtCount(courts_count) {
    if (courts_count == "1") {
      this.courtsCountOne();
    } else if (courts_count == "2") {
      this.courtsCountTwo();
    } else if (courts_count == "3") {
      this.courtsCountThree();
    } else {
      this.courtsCountOne();
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
    document.getElementById("court-2-container").style.visibility = 'none';
    document.getElementById("court-3-container").style.visibility = 'none';
    document.getElementById("court-4-container").style.visibility = 'none';
    document.getElementById("court-5-container").style.visibility = 'none';
    document.getElementById("court-6-container").style.visibility = 'none';
  };

  courtsCountTwo() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.visibility = 'none';
    document.getElementById("court-4-container").style.visibility = 'none';
    document.getElementById("court-5-container").style.visibility = 'none';
    document.getElementById("court-6-container").style.visibility = 'none';
  };

  courtsCountThree() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.display = 'block';
    document.getElementById("court-4-container").style.visibility = 'none';
    document.getElementById("court-5-container").style.visibility = 'none';
    document.getElementById("court-6-container").style.visibility = 'none';
  };  

  courtsCountFour() {
    document.getElementById("court-1-container").style.display = 'block';
    document.getElementById("court-2-container").style.display = 'block';
    document.getElementById("court-3-container").style.display = 'block';
    document.getElementById("court-4-container").style.display = 'block';
    document.getElementById("court-5-container").style.visibility = 'none';
    document.getElementById("court-6-container").style.visibility = 'none';
  };  
}