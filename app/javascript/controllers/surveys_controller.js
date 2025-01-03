// app/javascript/controllers/questions_controller.js
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["template", "questions", "category", "alternatives", "alternativeTemplate"]

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
        const question = event.target.closest(".question")
        const alternativesSection = question.querySelector("[data-category='alternatives']")
        if (event.target.value === "multiple_choice") {
            alternativesSection.classList.remove("hidden")
        } else {
            alternativesSection.classList.add("hidden")
            // Optionally clear alternatives if switching away from multiple choice
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
}
