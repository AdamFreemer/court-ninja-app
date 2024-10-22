import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { 
    id: Number
  }

  connect() {
    console.log("Team connected.");
  }
  
  delete(event) {
    let confirmed = confirm('Are you sure you want to delete this Team?');
    if (!confirmed) {
      event.preventDefault();
    } else {

      $.ajax({
        type: "DELETE",
        url: `/teams/${this.idValue}`,
        beforeSend: function(jqXHR, settings) {
          jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: (response) => {
          window.location.href = '/teams'
        }
      })
    }
  }
}
