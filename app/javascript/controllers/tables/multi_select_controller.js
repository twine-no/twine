import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ['checkAllCheckbox', 'rowCheckbox'];
    static values = {count: Number};

    async checkAll(event) {
        event.preventDefault();

        if (this.countValue >= 1) {
            for (const target of this.rowCheckboxTargets) {
                target.checked = false;
            }
            this.checkAllCheckboxTarget.checked = false;
            this.countValue = 0;
        } else {
            for (const target of this.rowCheckboxTargets) {
                target.checked = true;
            }
            this.countValue = this.rowCheckboxTargets.length;
        }
    }
}
