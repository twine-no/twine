import {Controller} from "@hotwired/stimulus";
import Sortable from "sortablejs";
import {request} from "helpers/request_helpers";

export default class extends Controller {
    static values = {updatePath: String};

    connect() {
        this.sortable = Sortable.create(this.element, {
            animation: 150,
            ghostClass: "bg-gray-200",
            onEnd: this.reorder.bind(this),
        });
    }

    async reorder() {
        const ids = Array.from(this.element.children).map((el) => el.dataset.id);

        await request("PATCH", this.updatePathValue, {
            contentType: "application/json",
            responseKind: "json",
            body: JSON.stringify({order: ids})
        });
    }
}
