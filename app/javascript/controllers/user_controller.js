import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { 
    id: Number,
    type: String,
    name: String,
  }

  connect() {

  }



  deactivate(event) {
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
          if (this.typeValue == "player") {
            window.location.href = "/players"
          }
          
          if (this.typeValue == "user") {
            window.location.href = "/users"
          }
        }
      })  
    }
  }
}
