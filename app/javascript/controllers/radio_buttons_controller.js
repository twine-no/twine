import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["radioButton", "hiddenField"]

    check(event) {
        event.preventDefault()

        const checkedRadioButton = event.currentTarget

        if (!!checkedRadioButton.dataset.radioButtonExclusive) {
            this.deselectAll()
            checkedRadioButton.classList.add("checked")
            this.hiddenFieldTarget.value = checkedRadioButton.dataset.value
        } else {
            this.deselectExclusiveRadioButtons()
            checkedRadioButton.classList.toggle("checked")
            const allCheckedRadioButtons = this.radioButtonTargets.filter(radioButton => radioButton.classList.contains("checked"))
            this.hiddenFieldTarget.value = allCheckedRadioButtons.map(radioButton => radioButton.dataset.value)
        }
    }

    deselectAll() {
        this.radioButtonTargets.forEach(radioButton => radioButton.classList.remove("checked"))
    }

    deselectExclusiveRadioButtons() {
        this.radioButtonTargets.forEach(radioButton => {
            if (!!radioButton.dataset.radioButtonExclusive) {
                radioButton.classList.remove("checked")
            }
        })
    }
}
