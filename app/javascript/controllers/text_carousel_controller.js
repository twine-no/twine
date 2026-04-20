import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  static values = {
    words: Array,
    interval: { type: Number, default: 2000 }
  }

  connect() {
    this.currentIndex = 0
    this.startRotation()
  }

  disconnect() {
    this.stopRotation()
  }

  startRotation() {
    this.timer = setInterval(() => {
      this.rotate()
    }, this.intervalValue)
  }

  stopRotation() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  rotate() {
    this.currentIndex = (this.currentIndex + 1) % this.wordsValue.length

    // Fade out
    this.textTarget.style.opacity = 0

    setTimeout(() => {
      this.textTarget.textContent = this.wordsValue[this.currentIndex]
      // Fade in
      this.textTarget.style.opacity = 1
    }, 200)
  }
}
