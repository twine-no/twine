import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["menu"];

    connect() {
        document.addEventListener("click", this.handleOutsideClick);
    }

    disconnect() {
        document.removeEventListener("click", this.handleOutsideClick);
    }

    toggle(event) {
        event.stopPropagation();
        this.menuTarget.classList.toggle("hidden");
    }

    handleOutsideClick = (event) => {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add("hidden");
        }
    };
}