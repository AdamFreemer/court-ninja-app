import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inviteCode", "teamName", "error", "teamNameContainer"];

  lookupInviteCode() {
    const inviteCode = this.inviteCodeTarget.value;

    if (inviteCode.length < 6) {
      this.errorTarget.classList.add("hidden");
      this.teamNameContainerTarget.classList.add("hidden");
    }

    if (inviteCode.length >= 6) {
      $.ajax({
        type: "GET",
        url: "/teams/verify",
        beforeSend: function (jqXHR, settings) {
          jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: {
          invite_code: inviteCode
        },
        success: (response) => {
          if (response.status === 'success') {
            this.teamNameTarget.innerHTML = response.team_name;
            this.errorTarget.classList.add("hidden");
            this.teamNameContainerTarget.classList.remove("hidden");
          } else {
            this.teamNameContainerTarget.classList.add("hidden");
            this.errorTarget.classList.remove("hidden");
          }
        }
      });
    }
  }
}