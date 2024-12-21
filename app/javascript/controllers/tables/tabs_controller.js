import {Controller} from "@hotwired/stimulus"
import {tableContentFor} from "helpers/tables_helper"

export default class extends Controller {
    static values = {tableGuid: String}
    static targets = ['tab']

    changeTab(event) {
        event.preventDefault()
        tableContentFor(this.application, this.tableGuidValue).update(
            {
                tab: event.currentTarget.dataset.tab || ''
            }
        )

        for (const tab of this.tabTargets) {
            tab.classList.remove("selected")
        }

        event.currentTarget.classList.add("selected")
    }
}
