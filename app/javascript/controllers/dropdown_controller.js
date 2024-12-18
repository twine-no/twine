import {Controller} from '@hotwired/stimulus'
import {useClickOutside} from 'stimulus-use'

export default class extends Controller {
    static targets = ['menu', 'button', 'icon']

    connect() {
        this.dropdownOpen = false
        useClickOutside(this, this.close)
    }

    toggle(e) {
        e.stopPropagation();
        this.dropdownOpen ? this.close(e) : this.open(e)
    }

    open(e) {
        e.preventDefault()

        if (this.hasIconTarget) {
            this.iconTarget.classList.add('rotate-180')
        }

        this.buttonTarget.setAttribute('aria-expanded', 'true')
        this.dropdownOpen = true

        this.menuTarget.classList.remove('hidden');
    }

    close(e) {
        e.preventDefault()

        if (this.hasIconTarget) {
            this.iconTarget.classList.remove('rotate-180')
        }

        this.buttonTarget.setAttribute('aria-expanded', 'false')
        this.dropdownOpen = false
        this.menuTarget.classList.add('hidden');
    }
}
