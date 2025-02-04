// app/javascript/controllers/questions_controller.js
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["template", "questions", "category", "alternatives", "alternativeTemplate"]

    connect() {
        this.categoryTargets.forEach((categoryTarget) => {
            this.toggleAlternativeSection(categoryTarget)
        })
    }

    addQuestion(event) {
        event.preventDefault()
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
        this.questionsTarget.insertAdjacentHTML("beforeend", content)
    }

    removeQuestion(event) {
        event.preventDefault()
        const question = event.target.closest(".question")
        if (question.dataset.newRecord === "true") {
            question.remove()
        } else {
            question.querySelector("input[name*='_destroy']").value = 1
            question.classList.add("hidden")
        }
    }

    toggleAlternatives(event) {
        this.toggleAlternativeSection(event.target)
    }

    toggleAlternativeSection(categoryTarget) {
        const question = categoryTarget.closest(".question")
        const alternativesSection = question.querySelector("[data-category='alternatives']")
        if (categoryTarget.value === "multiple_choice") {
            alternativesSection.classList.remove("hidden")
        } else {
            alternativesSection.classList.add("hidden")
            const alternativesInputs = alternativesSection.querySelectorAll("input")
            alternativesInputs.forEach(input => (input.value = ""))
        }
    }

    addAlternative(event) {
        event.preventDefault()
        const question = event.target.closest(".question")
        const alternativeTemplate = question.querySelector("[data-alternative-template]")
        const alternativesSection = question.querySelector("[data-category='alternatives']")
        const content = alternativeTemplate.innerHTML.replace(/NEW_ALT_RECORD/g, new Date().getTime())
        alternativesSection.insertAdjacentHTML("beforeend", content)
    }

    removeAlternative(event) {
        event.preventDefault()
        const alternative = event.target.closest("[data-surveys-alternative]")
        const destroyInputElement = alternative.querySelector("input[name*='_destroy']")
        console.log("destroyInputElement", destroyInputElement)
        if (destroyInputElement) {
            destroyInputElement.value = 1
            alternative.classList.add("hidden")
        } else {
            // New record, remove entirely from page
            alternative.remove()
        }
    }
}
