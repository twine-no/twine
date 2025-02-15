import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
    toggle(event) {
        event.currentTarget.classList.toggle("toggle-on")
        event.currentTarget.classList.toggle("toggle-off")
    }
}
