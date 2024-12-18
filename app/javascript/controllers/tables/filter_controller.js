import {Controller} from "@hotwired/stimulus";
import {tableContentFor} from "helpers/tables_helper"

export default class extends Controller {
    static values = {
        tableGuid: String,
        filterValues: Array
    }

    static targets = ['checkbox', 'statusIndicator']

    connect(){
        this.#readoutCheckboxValues()
    }

    applyFilter(event) {
        this.#readoutCheckboxValues()
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
        let numberOfBoxesChecked = 0
        for (let checkbox of this.checkboxTargets) {
            if (checkbox.checked) {
                numberOfBoxesChecked++
                this.#addOptions(checkbox.value)
            } else {
                this.#removeOptions(checkbox.value)
            }
        }

        this.#updateStatusIndicator(numberOfBoxesChecked)
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

    #updateStatusIndicator(numberOfBoxesChecked){
        if(numberOfBoxesChecked === 0 || numberOfBoxesChecked == this.checkboxTargets.length){
            this.statusIndicatorTarget.classList.add("hidden")
        } else {
            this.statusIndicatorTarget.classList.remove("hidden")
        }

        this.statusIndicatorTarget.innerHTML = numberOfBoxesChecked
    }
}
