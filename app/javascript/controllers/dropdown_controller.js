import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["button", "dropdown"];

  connect() {
    this.buttonTarget.addEventListener("click", this.openUserMenu.bind(this));
  }

  openUserMenu() {
    console.log(this.dropdownTarget.classList);
    if (this.dropdownTarget.classList.contains("hidden")) {
      this.dropdownTarget.classList.remove("hidden");
    } else {
      this.dropdownTarget.classList.add("hidden");
    }
  }

  disconnect() {
    this.buttonTarget.removeEventListener(
      "click",
      this.openUserMenu.bind(this)
    );
  }
}
