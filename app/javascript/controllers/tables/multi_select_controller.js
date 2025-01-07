import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['checkAllCheckbox', 'rowCheckbox']
    static values = {count: Number}

    async checkAll(event) {
        event.preventDefault()

        if (this.countValue >= 1) {
            for (const target of this.rowCheckboxTargets) {
                target.checked = false
            }
            this.checkAllCheckboxTarget.checked = false
            this.updateCount()
        } else {
            for (const target of this.rowCheckboxTargets) {
                target.checked = true
            }
            this.updateCount()
        }
    }

    async check() {
        this.updateCount()
    }

    updateCount() {
        const selectedRowIds = this.rowCheckboxTargets.filter(checkbox => checkbox.checked).map(checkbox => checkbox.value)
        this.countValue = selectedRowIds.length
        const multiSelectHiddenFields = document.querySelectorAll('[data-multi-select-hidden-field]')

        for (let formInputOutlet of multiSelectHiddenFields) {
            formInputOutlet.value = selectedRowIds
        }

        const multiSelectMenu = document.querySelector("[data-multi-select-menu]")
        const multiSelectMenuLabel = document.querySelector("[data-multi-select-menu-label]")

        if (this.countValue > 0) {
            multiSelectMenuLabel.textContent = `${this.countValue}`
            multiSelectMenu.classList.remove("hidden")
        } else {
            multiSelectMenu.classList.add("hidden")
        }
    }
}
