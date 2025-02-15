import {Controller} from '@hotwired/stimulus'
import {miniFlash} from "lib/flashes";

export default class extends Controller {
    static values = {copyText: String}

    async copy(event) {
        event.preventDefault()
        await navigator.clipboard.writeText(this.copyTextValue)
        this.showConfirmation()
    }

    showConfirmation() {
        miniFlash("Copied!", 800, this.element)
    }
}
