import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "copied"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)
    this.copiedTarget.classList.remove("hidden");
    setTimeout(() => this.copiedTarget.remove(), 5000)

  }
}