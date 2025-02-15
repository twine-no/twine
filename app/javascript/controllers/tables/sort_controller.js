import {Controller} from "@hotwired/stimulus"
import {tableContentFor} from "helpers/tables_helpers"

export default class extends Controller {
    static values = {sortBy: String, sortDirection: String, tableGuid: String};
    static targets = ['sortIcon']

    toggleSortDirection() {
        this.toggleSearchDirection();
        this.setSortIcons();

        tableContentFor(this.application, this.tableGuidValue).update(
            {
                sortBy: this.sortByValue,
                sortDirection: this.sortDirectionValue
            }
        )
    }

    toggleSearchDirection() {
        this.sortDirectionValue = this.sortDirectionValue === 'asc' ? 'desc' : 'asc';
    }

    setSortIcons() {
        const faSortIcon = this.sortDirectionValue === 'asc' ? 'fa-sort-up' : 'fa-sort-down';
        document.querySelectorAll('[data-tables--table-header-target="sortIcon"]').forEach((icon) => {
            icon.classList.remove('fa-sort-up', 'fa-sort-down');
        });
        this.sortIconTarget.classList.add(faSortIcon)
    }
}
