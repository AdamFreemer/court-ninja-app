import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // console.log('-- Users Controller Connect')
    // setTimeout(() => {
    //   this.dismiss();
    // }, 5000);
  }

  newTeamPlayer() {
    window.location.href = `/players/new?type=team`
  }

  newOneOffPlayer() {
    window.location.href = `/players/new?type=one_off`
  }  

  newUser() {
    window.location.href = `/users/new`
  }  

  dismiss() {
    this.element.remove();
  }
}
