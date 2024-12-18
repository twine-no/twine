import {Controller} from "@hotwired/stimulus";
import {tableContentFor} from "helpers/tables_helper"

export default class extends Controller {
    static values = {
        tableGuid: String,
        filterValues: Array,
    }

    static targets = ['checkbox']

    applyFilter(event) {
        this.#readoutCheckboxValues()

        console.log("updating filters to", this.filterValuesValue)
        tableContentFor(this.application, this.tableGuidValue).update(
            {
                filters: {
                    name: event.target.name,
                    value: this.filterValuesValue
                }
            }
        )
    }

   #readoutCheckboxValues() {
        for (let checkbox of this.checkboxTargets) {
            if (checkbox.checked) {
                this.#addOptions(checkbox.value)
            } else {
                this.#removeOptions(checkbox.value)
            }
        }
    }

    #addOptions(value) {
        const valuesArray = value.split(',')
        let newArray = this.filterValuesValue
        for (const value of valuesArray) {
            newArray.push(value)
        }
        this.filterValuesValue = newArray
    }

    #removeOptions(value) {
        const valuesArray = value.split(',')
        this.filterValuesValue = this.filterValuesValue.filter((option) => !valuesArray.includes(option))
    }
}
