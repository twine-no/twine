import {Controller} from "@hotwired/stimulus";

// The editor saves in the background and then refreshes the page by morphing it.
// Without this, a refresh that arrives while somebody is typing would overwrite the field they are in.
export default class extends Controller {
    skipFocusedField(event) {
        if (event.target === document.activeElement) {
            event.preventDefault();
        }
    }
}
