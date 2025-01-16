import {Controller} from '@hotwired/stimulus'
import {useClickOutside} from 'stimulus-use'

export default class extends Controller {
    static targets = ['modal', 'contentWrapper']
    static values = {openOnPageLoad: Boolean, originUrl: String}

    connect() {
        useClickOutside(this, {element: this.contentWrapperTarget})

        if (this.openOnPageLoadValue) {
            this.open()
        }
    }

    clickOutside(event) {
        this.close(event)
    }

    async open() {
        this.modalTarget.showModal()
        this.modalTarget.classList.add("modal-open")
    }

    close(event) {
        event.preventDefault()
        this.modalTarget.close()
        this.modalTarget.classList.remove("modal-open")
    }
}
