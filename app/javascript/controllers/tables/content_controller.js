import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = [
        'form',
        'sortByInput',
        'sortDirectionInput',
        'filterInput',
        'searchTermInput',
        'tabInput',
        'row',
        'perPageInput',
        'table'
    ];
    static values = {userId: Number, maxRowCount: Number};

    update({sortBy, sortDirection, searchTerm, filters, tab}) {
        this.showLoader();
        this.updateContentParams(sortBy, sortDirection, searchTerm, filters, tab);
        this.submitForm();
    }

    showLoader() {
        this.rowTargets.forEach((row) => {
            row.classList.add('opacity-50');
        });
    }

    loadAllRecords() {
        this.perPageInputTarget.value = this.maxRowCountValue;
        this.submitForm();
    }

    submitForm() {
        this.formTarget.requestSubmit();
    }

    allRecordsAreLoaded() {
        return this.rowTargets.length === this.maxRowCountValue;
    }

    async ensureAllRecordsAreLoaded() {
        return new Promise((resolve) => {
            const interval = setInterval(() => {
                if (this.allRecordsAreLoaded()) {
                    clearInterval(interval);
                    resolve();
                }
            }, 50);
        });
    }

    updateContentParams(sortBy, sortDirection, searchTerm, filter, tab) {
        if (sortBy !== undefined) {
            this.sortByInputTarget.value = sortBy;
        }

        if (sortDirection !== undefined) {
            this.sortDirectionInputTarget.value = sortDirection;
        }

        if (searchTerm !== undefined) {
            this.searchTermInputTarget.value = searchTerm;
        }

        if (tab !== undefined) {
            this.tabInputTarget.value = tab;
        }

        if (filter !== undefined) {
            const filterInput = this.filterInputTargets.find(
                (input) => input.name === `filters[${filter.name}]`);
            filterInput.value = filter.value;
        }
    }
}
