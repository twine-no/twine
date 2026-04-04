import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "row"]

  preview(event) {
    this.updateTrackFill(event.currentTarget)
  }

  async save(event) {
    const slider = event.currentTarget
    this.updateTrackFill(slider)

    const membershipId = slider.dataset.membershipId
    const feeling = slider.value

    await fetch(`/admin/memberships/${membershipId}/feeling`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ feeling })
    })
  }

  updateTrackFill(slider) {
    const pct = ((slider.value - slider.min) / (slider.max - slider.min)) * 100
    slider.style.setProperty("--fill-pct", `${pct}%`)
  }

  connect() {
    this.sliderTargets.forEach(slider => this.updateTrackFill(slider))
  }
}
