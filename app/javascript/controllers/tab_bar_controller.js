import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { active: { type: String, default: "work" }, storageKey: String }
  static targets = ["tab", "panel"]

  connect() {
    if (this.hasStorageKeyValue) {
      const stored = localStorage.getItem(this.storageKeyValue)
      if (stored) this.activeValue = stored
    }
  }

  select(event) {
    this.activeValue = event.currentTarget.dataset.tab
    if (this.hasStorageKeyValue) {
      localStorage.setItem(this.storageKeyValue, this.activeValue)
    }
  }

  activeValueChanged(value) {
    this.tabTargets.forEach(tab => tab.classList.toggle("tab-active", tab.dataset.tab === value))
    this.panelTargets.forEach(panel => { panel.hidden = panel.dataset.tab !== value })
  }
}
