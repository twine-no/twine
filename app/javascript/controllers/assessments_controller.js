import { Controller } from "@hotwired/stimulus"

const FEELING_LABELS = ["Terribly", "Poorly", "Worryingly", "Not good", "Meh", "Ok", "Good", "Great", "Amazing", "Perfect"]
const THUMB_WIDTH = 18
const SPARK_COLORS = ["#4ade80", "#facc15", "#fb923c", "#a78bfa", "#38bdf8"]

export default class extends Controller {
  static targets = ["slider"]

  sliderTargetConnected(slider) {
    this.updateTrackFill(slider)
    this.hideLabel(slider)
  }

  sliderTargetDisconnected(slider) {
    clearTimeout(this.labelTimers?.[slider.id])
    this.hideLabel(slider)
  }

  preview(event) {
    const slider = event.currentTarget
    this.updateTrackFill(slider)
    this.showLabel(slider)
    clearTimeout(this.labelTimers?.[slider.id])

    if (parseInt(slider.value) === 100) this.emitSparks(slider)
  }

  async save(event) {
    const slider = event.currentTarget
    this.updateTrackFill(slider)
    this.scheduleHideLabel(slider)

    await fetch(slider.dataset.actionUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ value: slider.value })
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

    const label = document.getElementById(slider.dataset.labelId)
    if (label) {
      label.textContent = FEELING_LABELS[Math.min(Math.floor(pct * 10), 9)]
      label.style.color = color
      label.style.left = `${pct * (slider.offsetWidth - THUMB_WIDTH) + THUMB_WIDTH / 2}px`
    }
  }

  showLabel(slider) {
    const label = document.getElementById(slider.dataset.labelId)
    if (label) {
      label.classList.remove("opacity-0")
      label.classList.add("opacity-100")
    }
  }

  hideLabel(slider) {
    const label = document.getElementById(slider.dataset.labelId)
    if (label) {
      label.classList.remove("opacity-100")
      label.classList.add("opacity-0")
    }
  }

  scheduleHideLabel(slider) {
    this.labelTimers ||= {}
    this.labelTimers[slider.id] = setTimeout(() => this.hideLabel(slider), 1200)
  }

  emitSparks(slider) {
    const rect = slider.getBoundingClientRect()
    const thumbX = rect.left + rect.width - THUMB_WIDTH / 2
    const thumbY = rect.top + rect.height / 2

    for (let i = 0; i < 8; i++) {
      const spark = document.createElement("span")
      const color = SPARK_COLORS[i % SPARK_COLORS.length]
      const angle = (i / 8) * 2 * Math.PI
      const distance = 28 + Math.random() * 18
      const tx = Math.cos(angle) * distance
      const ty = Math.sin(angle) * distance

      spark.style.cssText = `
        position: fixed;
        pointer-events: none;
        width: 5px; height: 5px;
        border-radius: 50%;
        background: ${color};
        left: ${thumbX}px;
        top: ${thumbY}px;
        transform: translate(-50%, -50%);
        animation: spark-fly 0.55s ease-out forwards;
        --tx: ${tx}px; --ty: ${ty}px;
        z-index: 9999;
      `
      document.body.appendChild(spark)
      spark.addEventListener("animationend", () => spark.remove(), { once: true })
    }
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
