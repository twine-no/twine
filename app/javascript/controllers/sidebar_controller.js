import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["sidebar", "sidebarMenu", "sidebarBackdrop", "closeButton"]

    connect() {
        document.addEventListener("click", this.handleOutsideClick)
    }

    disconnect() {
        document.removeEventListener("click", this.handleOutsideClick)
    }

    toggle(event) {
        if (this.sidebarTarget.classList.contains("hidden")) {
            this.openSidebar()
        } else {
            this.closeSidebar()
        }
    }

    handleOutsideClick = (event) => {
        if (!this.element.contains(event.target)) {
            this.closeSidebar()
        }
    };

    openSidebar() {
        this.sidebarTarget.classList.remove("hidden");
        this.sidebarMenuTarget.classList.replace("slide-out", "slide-in");
        this.sidebarBackdropTarget.classList.replace("fade-out", "fade-in");
        this.closeButtonTarget.classList.replace("fade-out", "fade-in")

    }

    closeSidebar() {
        this.sidebarMenuTarget.classList.replace("slide-in", "slide-out");
        this.sidebarBackdropTarget.classList.replace("fade-in", "fade-out");
        this.closeButtonTarget.classList.replace("fade-in", "fade-out");

        // Wait for the transition to finish before hiding the sidebar entirely
        this.sidebarMenuTarget.addEventListener("transitionend", () => {
            this.sidebarTarget.classList.add("hidden");
        }, {once: true})
    }
}
