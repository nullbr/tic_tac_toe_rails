import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="game-mode"
export default class extends Controller {
  static targets = ["level", "mode", "player"];

  eval() {
    if (this.modeTarget.value === "2" || this.modeTarget.value === "3") {
      this.levelTarget.style.display = "block";
    } else if (this.modeTarget.value === "1") {
      this.playerTarget.style.display = "block";
    } else {
      this.levelTarget.style.display = "none";
      this.playerTarget.style.display = "block";
    }
  }
}
