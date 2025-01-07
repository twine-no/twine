import {Controller} from "@hotwired/stimulus"
import {delay} from 'helpers/timing_helpers'
import {tableContentFor} from 'helpers/tables_helpers'

export default class extends Controller {
    static targets = ['searchInputContainer']
    static values = {
        lastSearchIdentifier: String,
        lastSearchTerm: String,
        tableGuid: String,
    }

    SEARCH_COOLDOWN_TIME = 250 // ms
    MINIMUM_CHARACTER_LIMIT = 2

    async handleNewSearchTerm(event) {
        let searchTerm = event.target.value

        if (!this.searchTermWasChanged(searchTerm)) {
            return
        }

        if (this.searchTermIsCorrectLength(searchTerm)) {
            this.search(searchTerm)
        } else if (this.hadSearchedPreviously()) {
            this.search(searchTerm)
            tableContentFor(this.application, this.tableGuidValue).update({searchTerm: ''})
        }
    }

    hadSearchedPreviously() {
        return !!this.lastSearchTermValue
    }

    searchTermIsCorrectLength(searchTerm) {
        return searchTerm.length >= this.MINIMUM_CHARACTER_LIMIT
    }

    searchTermWasChanged(searchTerm) {
        return searchTerm !== this.lastSearchTermValue
    }

    async search(searchTerm) {
        if (await this.searchWasCancelled()) {
            return
        }
        this.lastSearchTermValue = searchTerm

        if (this.lastSearchTermValue === '') {
            return
        }

        tableContentFor(this.application, this.tableGuidValue).update({searchTerm})
    }

    async searchWasCancelled() {
        let currentSearchIdentifier = Math.random().toString().substring(2, 14)
        this.lastSearchIdentifierValue = currentSearchIdentifier
        await delay(this.SEARCH_COOLDOWN_TIME)
        return this.lastSearchIdentifierValue !== currentSearchIdentifier
    }
}
