import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { 
    id: Number,
    type: String,
    name: String,
  }

  connect() {
    // setTimeout(() => {
    //   this.dismiss();
    // }, 5000);
  }



  deactivate(event) {
    console.log('=== deactivate new!')
    let confirmed = confirm('Are you sure you want to delete ' + this.nameValue + '?');
    if (!confirmed) {
      event.preventDefault();
    } else {
      $.ajax({
        type: "POST",
        url: "/user_deactivate/",
        beforeSend: function(jqXHR, settings) {
          jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: {
          id: this.idValue,
        },
        success: (response) => {
          console.log("-- successful delete")
          console.log("-- type: " + this.typeValue)
          if (this.typeValue == "player") {
            window.location.href = "/players"
          }
          
          if (this.typeValue == "user") {
            console.log("---- wtf")
            window.location.href = "/users"
            console.log("---- wtf")
          }
        }
      })  
    }
  }
}
