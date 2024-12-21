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

    open() {
        this.modalTarget.showModal()
    }

    close(event) {
        event.preventDefault()
        this.modalTarget.close()

        // rethink, needs to be encapsulating view in case you arrive directly at modal view
        history.pushState({}, "", this.originUrlValue)
    }
}
