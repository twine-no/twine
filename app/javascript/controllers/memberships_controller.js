import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider"]

  sliderTargetConnected(slider) {
    this.updateTrackFill(slider)
  }

  preview(event) {
    this.updateTrackFill(event.currentTarget)
  }

  async save(event) {
    const slider = event.currentTarget
    this.updateTrackFill(slider)

    await fetch(slider.dataset.actionUrl, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ feeling: slider.value })
    })

    slider.classList.add("feeling-saved")
    slider.addEventListener("animationend", () => slider.classList.remove("feeling-saved"), { once: true })
  }

  updateTrackFill(slider) {
    const pct = (slider.value - slider.min) / (slider.max - slider.min)
    const color = this.feelingColor(pct)
    slider.style.setProperty("--fill-pct", `${pct * 100}%`)
    slider.style.setProperty("--fill-color", color)
    slider.style.setProperty("--glow-color", color.replace("rgb(", "rgba(").replace(")", ", 0.28)"))
  }

  feelingColor(pct) {
    if (pct < 0.5) {
      const t = pct * 2
      return `rgb(${Math.round(248 + (251 - 248) * t)}, ${Math.round(113 + (191 - 113) * t)}, ${Math.round(113 + (36 - 113) * t)})`
    } else {
      const t = (pct - 0.5) * 2
      return `rgb(${Math.round(251 + (74 - 251) * t)}, ${Math.round(191 + (222 - 191) * t)}, ${Math.round(36 + (128 - 36) * t)})`
    }
  }
}
