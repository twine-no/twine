import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
    static targets = ["input"]

    toggle(event) {
        event.preventDefault()

        this.inputTarget.disabled = !this.inputTarget.disabled
        if (this.inputTarget.disabled) {
            this.inputTarget.classList.add("hidden")
            event.target.innerText = "Set date"
            event.currentTarget.classList.add("radio-button")
            event.currentTarget.classList.remove("button")
        } else {
            this.inputTarget.classList.remove("hidden")
            event.target.innerText = "Decide later"
            event.currentTarget.classList.remove("radio-button")
            event.currentTarget.classList.add("button")
        }
    }
}
