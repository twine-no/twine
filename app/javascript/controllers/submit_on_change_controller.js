import { Controller } from "@hotwired/stimulus"

// Handles auto-submit behavior in forms.
// For regular inputs we submit on change (default browser blur/change event).
// For Trix rich text areas we only submit on blur; trix-change is ignored.
export default class extends Controller {
  static targets = ["submitButton"]

  submit(event) {
    if (event.type === "trix-change") return

    this.submitButtonTarget.click()
  }
}
