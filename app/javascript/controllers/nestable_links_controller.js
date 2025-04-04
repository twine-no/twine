import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    handleClick(event) {
        // if the element is clicked
        if (!event.target.dataset.href) {
            return;
        }

        event.stopImmediatePropagation()
        event.preventDefault()
        window.location.href = event.target.dataset.href

    }
}
