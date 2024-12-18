import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['selectAllCheckbox', 'recordCheckbox'];
  static values = {
    checkedMap: Object,
    count: { type: Number, default: 0 }
  };

  connect() {
    document.addEventListener('turbo:frame-load', this.recheckCheckboxes.bind(this));
    this.recheckCheckboxes();
  }

  disconnect() {
    document.removeEventListener('turbo:frame-load', this.recheckCheckboxes.bind(this));
  }

  async selectAll(event) {
    if (!this.contentController) return;

    event.preventDefault();
    if (this.countValue >= 1) {
      for (const target of this.recordCheckboxTargets) {
        target.checked = false;
        this.updateCheckedMap(target.value, false);
      }
      this.selectAllCheckboxTarget.checked = false;
      this.checkedMapValue = {};
      this.countValue = 0;
    } else {
      for (const target of this.recordCheckboxTargets) {
        target.checked = true;
        this.updateCheckedMap(target.value, true);
      }
      this.countValue = this.recordCheckboxTargets.length;
    }
  }

  selectItem(e) {
    e.preventDefault();

    const isChecked = e.target.checked;
    const id = e.target.value;
    this.updateCheckedMap(id, isChecked);

    if (isChecked) {
      this.countValue += 1;
    } else if (this.countValue > 0) {
      this.countValue -= 1;
    }

    if (this.countValue < this.recordCheckboxTargets.length) {
      this.selectAllCheckboxTarget.checked = false;
    }
  }

  updateCheckedMap(id, isChecked) {
    if (isChecked) {
      this.checkedMapValue = {
        ...this.checkedMapValue,
        [id]: true
      };
    } else {
      // Remove the id from the object
      const { [id]: _, ...rest } = this.checkedMapValue;
      this.checkedMapValue = rest;
    }
  }

  set countValue(newCount) {
    this.data.set("count", newCount);

    document.dispatchEvent(
      new CustomEvent('selectCountChanged', { detail: newCount })
    );
  }

  get countValue() {
    return Number(this.data.get("count"));
  }

  /**
   * @returns {string[]}
   */
  getSelectedRecordIds() {
    return Object.keys(this.checkedMapValue);
  }

  /**
   * When a turbo frame is loaded, recheck the checkboxes to ensure they are in sync with the checkedMapValue
   */
  recheckCheckboxes() {
    for (const target of this.recordCheckboxTargets) {
      if (this.checkedMapValue[target.value]) {
        target.checked = true;
      }
    }
  }

  get contentController() {
    const element = document.querySelector(
      '[data-controller~=tables--content]'
    );
    if (!element) return null;

    return this.application.getControllerForElementAndIdentifier(
      element,
      'tables--content'
    );
  }
}
