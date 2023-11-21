import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { 
    id: Number,
    type: String,
  }

  connect() {
    console.log('-- User Controller Connect')
    // setTimeout(() => {
    //   this.dismiss();
    // }, 5000);
  }



  delete(event) {
    console.log('-- type:' + this.typeValue)
    let confirmed = confirm('Are you sure you want to delete this player?');
    console.log('user id: ' + this.idValue)
    if (!confirmed) {
      event.preventDefault();
    } else {
      $.ajax({
        type: "POST",
        url: "/user_delete/",
        beforeSend: function(jqXHR, settings) {
          jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: {
          id: this.idValue,
        },
        success: (response) => {
          console.log("-- successful delete")
          console.log(response)
          if (this.typeValue == "player") {
            window.location.href = "/players"
          }
          
          if (this.typeValue == "user") {
            window.location.href = "/admin"
          }
        }
      })  
    }
  }
}
