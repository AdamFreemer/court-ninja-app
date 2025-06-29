import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  change() {
    let e = document.getElementById("filter");
    let filter = e.value;

    $.ajax({
      type: "GET",
      url: "/tournaments",
      beforeSend: function(jqXHR, settings) {
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        filter: filter,
      },
      success: function (response) {
      }
    })
  }
}