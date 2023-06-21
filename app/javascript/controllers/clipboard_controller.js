import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static values = { link: String };

  connect() {
    this.element.addEventListener("click", this.copyToClipboard.bind(this));
  }

  copyToClipboard() {
    navigator.clipboard
      .writeText(this.linkValue)
      .then(() => {
        alert("Invite link copied to clipboard");
        // You can display a success message or perform any other action here
      })
      .catch((error) => {
        alert("Failed to copy invite link to clipboard", error);
        // You can display an error message or handle the error in an appropriate way
      });
  }
}
