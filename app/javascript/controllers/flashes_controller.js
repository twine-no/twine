import { Controller } from "@hotwired/stimulus";
import { flash } from 'lib/flashes';

export default class extends Controller {
    static values = { message: String };

    connect() {
        flash(this.messageValue);
    }
}
