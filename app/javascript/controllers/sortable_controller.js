import {Controller} from "@hotwired/stimulus";
import Sortable from "sortablejs";

// Lets the list be reordered by dragging, and submits the order form when an item is dropped.
// The order form picks up the new order from hidden fields that travel with each item.
export default class extends Controller {
    static targets = ["list", "orderForm"];

    connect() {
        this.sortable = Sortable.create(this.listTarget, {
            animation: 150,
            handle: "[data-sortable-handle]",
            onEnd: () => this.orderFormTarget.requestSubmit(),
        });
    }

    disconnect() {
        this.sortable.destroy();
    }
}
