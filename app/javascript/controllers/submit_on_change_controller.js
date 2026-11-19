import { Controller } from "@hotwired/stimulus"

// Saves a form as soon as one of its fields changes, by clicking its (hidden) submit button.
export default class extends Controller {
  static targets = ["submitButton"]

  submit() {
    this.submitButtonTarget.click()
  }
}
