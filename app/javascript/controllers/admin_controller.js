import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    tournamentId: Number,
    tournamentCurrentRoundLocal: Number,
    tournamentCurrentRoundServer: Number,
    breakTime: Number, 
    tournamentTime: Number, // static value for Tournament Time
    tournamentTimer: Number, // Actual countdown timer value
    tournamentTimerState: String, // "run", "stop", "initial", "reset"
    localViewId: Number, // unique id of browser window / tab - created on every init connect
    currentAdminViewIdServer: Number, // current admin view in control, from server
  }
  static targets = [ "minute", "second", "enabled", "start", "pause", "reset", "timerWarning", "timerOffline", "spinner" ]

  connect() {
    this.timerOfflineTarget.style.display = 'none';
    this.timerWarningTarget.style.display = 'block';
    this.updateTimerOnPage();
    // generate new unique admin view id on initial load / refresh
    this.localViewIdValue = Math.floor(Math.random() * 1000000)
    this.activeConnection("sync", null) // initial sync / load
    this.activeConnectionStart(); // start active monitoring of admin views
  };

  // this is the "always running while page is loaded" server status fetch timer
  activeConnectionStart() {
    this.activeConnectionTimer = setInterval(() => {
      this.activeConnection("sync", null)
    }, 2000);
  }

  activeConnection(state, timer_time) {
    const current_time = Math.floor(Date.now() / 1000) // last_update on server
    // state: "sync", "run", "stop", "initial", "reset" (default on creation: "initial")
    $.ajax({
      type: "POST",
      url: "/tournaments/admin_connection",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        id: this.tournamentIdValue,
        state: state,
        time: timer_time,
        view: { id: this.localViewIdValue, timestamp: current_time }
      },
      success: (response) => {
        this.tournamentTimerStateValue = response.timer_state;
        this.tournamentTimerValue = response.timer_time;
        this.currentAdminViewIdServerValue = response.current_view;
      }
    })
    this.realTimeLogic();
  };

  realTimeLogic() {
    this.timerLoadingWarning();
    this.timerOfflineWarning();
    this.timerControlsEnablement();
    this.updateTimerOnPage();
    this.updateTimerSpinner();
    if (!this.timer && this.tournamentTimerStateValue == "run") {
      this.timerRun();
    }
  }

  timerLoadingWarning() {
    console.log("=== this.currentAdminViewIdServer: " + this.currentAdminViewIdServerValue)
    if (this.currentAdminViewIdServerValue) {
      this.timerWarningTarget.style.display = 'none';
    }
  }

  timerOfflineWarning() {
    if (this.currentAdminViewIdServerValue != this.localViewIdValue && this.currentAdminViewIdServerValue != 0) {
      this.timerOfflineTarget.style.display = 'block';
    } else {
      this.timerOfflineTarget.style.display = 'none';
    }
  }

  timerControlsEnablement() {
    if (this.localViewIdValue == this.currentAdminViewIdServerValue) {
      // timer controls enabled
      this.startTarget.classList.add('bg-green-200', 'hover:bg-green-300');
      this.pauseTarget.classList.add('bg-yellow-200', 'hover:bg-yellow-300');
      this.resetTarget.classList.add('bg-red-200', 'hover:bg-red-300');
      this.startTarget.classList.remove('bg-gray-200', "opacity-50", "cursor-not-allowed");
      this.pauseTarget.classList.remove('bg-gray-200', "opacity-50", "cursor-not-allowed");
      this.resetTarget.classList.remove('bg-gray-200', "opacity-50", "cursor-not-allowed");

      this.startTarget.disabled = false;
      this.pauseTarget.disabled = false;
      this.resetTarget.disabled = false;
    } else {
      // timer controls disabled
      this.startTarget.classList.remove('bg-green-200', 'hover:bg-green-300');
      this.pauseTarget.classList.remove('bg-yellow-200', 'hover:bg-yellow-300');
      this.resetTarget.classList.remove('bg-red-200', 'hover:bg-red-300');
      this.startTarget.classList.add("bg-gray-200", "opacity-50", "cursor-not-allowed");
      this.pauseTarget.classList.add("bg-gray-200", "opacity-50", "cursor-not-allowed");
      this.resetTarget.classList.add("bg-gray-200", "opacity-50", "cursor-not-allowed");

      this.startTarget.disabled = true;
      this.pauseTarget.disabled = true;
      this.resetTarget.disabled = true;
      // always remove spinner when transport stops
      this.spinnerTarget.style.display = 'none';
    }
  }

  // timer controls /////////////////////////////////////////////////////////////////
  start() {
    this.activeConnection("run", this.tournamentTimerValue);
    this.timerRun();
    this.spinnerTarget.style.display = 'inline-block';
  }
  pause() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    this.activeConnection("stop", this.tournamentTimerValue);
    this.spinnerTarget.style.display = 'none';
  }
  reset() {
    clearInterval(this.timer);
    this.tournamentTimerValue = (this.breakTimeValue + this.tournamentTimeValue)
    this.updateTimerOnPage();
    this.spinnerTarget.style.display = 'none';
    this.activeConnection("reset", this.breakTimeValue + this.tournamentTimeValue);
  }
  ///////////////////////////////////////////////////////////////////////////////////

  timerRun() {
    this.timer = setInterval(() => {
      this.timerDecrement();
    }, 1000);
  }

  timerDecrement() {
    this.tournamentTimerValue--
    const totalMatchTime = this.breakTimeValue + this.tournamentTimeValue
    if (this.tournamentTimerValue <= 0) {
      clearInterval(this.timer);
      this.activeConnection("reset", totalMatchTime);
      this.spinnerTarget.style.display = 'none';
    } else {
      this.activeConnection(this.tournamentTimerStateValue, this.tournamentTimerValue);
    }
  };

  updateTimerSpinner() {
    if (this.tournamentTimerStateValue == "run") {
      this.spinnerTarget.style.display = 'inline-block';
    } else {
      this.spinnerTarget.style.display = 'none';
    }    
  }
  
  updateTimerOnPage() {
    const totalMatchTime = this.breakTimeValue + this.tournamentTimeValue
    let time;
    this.tournamentTimerState == "initial" ? time = totalMatchTimeValue : time = this.tournamentTimerValue;
    let second = time % 60;
    let minute = Math.floor(time / 60) % 60;
    second = (second < 10) ? '0'+ second : second;
    minute = (minute < 10) ? + minute : minute;
    this.minuteTarget.innerHTML = minute
    this.secondTarget.innerHTML = second
  };
}