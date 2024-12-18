import {Controller} from '@hotwired/stimulus'
import {useClickOutside} from 'stimulus-use'

export default class extends Controller {
    static targets = ['dialog']
    static values = {
        isModal: Boolean
    }

    connect() {
        useClickOutside(this, this.close)
    }

    toggle(e) {
        e.stopPropagation();
        this.dialogTarget.open ? this.close(e) : this.open(e)
    }

    open(e) {
        e.preventDefault()
        this.isModalValue ? this.dialogTarget.showModal() : this.dialogTarget.show()
    }

    close(e) {
        e.preventDefault()
        this.dialogTarget.close()
    }
}
