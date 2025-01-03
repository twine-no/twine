import {Controller} from '@hotwired/stimulus'
import {useClickOutside} from 'stimulus-use'

export default class extends Controller {
    static targets = ["dropdown", "option", "hiddenField", "searchField"]

    connect() {
        useClickOutside(this, {element: this.element})
    }

    clickOutside(_event) {
        this.hideDropdown()
    }

    showDropdown() {
        this.dropdownTarget.classList.remove("hidden")
    }

    hideDropdown() {
        this.dropdownTarget.classList.add("hidden")
    }

    checkIfDropdownShouldBeShown() {
        if (this.searchFieldTarget.value.trim().length > 0) {
            this.showDropdown()
        } else {
            this.hideDropdown()
        }
    }

    detectFormSubmit(event) {
        if (event.key !== "Enter") {
            return
        }
        event.preventDefault()

        const selectedOption = this.optionTargets.find((element) => {
            return !element.classList.contains("hidden")
        })

        if (!!selectedOption) {
            this.hiddenFieldTarget.value = selectedOption.dataset.value
            this.#submitForm()
        }
    }

    filterOptions(event) {
        this.checkIfDropdownShouldBeShown()
        const searchTerm = event.target.value.toLowerCase().trim()
        this.optionTargets.forEach(option => {
            if (option.dataset.searchableBy.toLowerCase().includes(searchTerm)) {
                option.classList.remove("hidden")
                this.#highlightOptionText(option, searchTerm)
            } else {
                option.classList.add("hidden")
            }
        })
    }

    selectOption(event) {
        this.hiddenFieldTarget.value = event.currentTarget.dataset.value
        this.#submitForm()
    }

    pressEnterOnOption(event) {
        if (event.key !== "Enter") {
            return
        }

        this.selectOption(event)
    }

    #submitForm() {
        this.searchFieldTarget.value = ""
        this.hideDropdown()
        this.hiddenFieldTarget.form.requestSubmit()
    }

    #highlightOptionText(option, searchTerm) {
        const highlightStartIndex = option.dataset.searchableBy.toLowerCase().indexOf(searchTerm)
        const highlightEndIndex = highlightStartIndex + searchTerm.length

        const leadingText = option.dataset.searchableBy.slice(0, highlightStartIndex)
        const highlightedText = option.dataset.searchableBy.slice(highlightStartIndex, highlightEndIndex)
        const trailingText = option.dataset.searchableBy.slice(highlightEndIndex)

        option.innerHTML = `${leadingText}<strong>${highlightedText}</strong>${trailingText}`
    }
}
