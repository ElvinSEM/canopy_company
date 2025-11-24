// app/frontend/controllers/login_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["emailIndicator", "passwordIndicator", "submitBtn"]

    connect() {
        this.updateSubmitButton()
    }

    validateEmail(event) {
        const email = event.target.value.trim()
        const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)

        this.emailIndicatorTarget.classList.toggle('opacity-0', !isValid)
        this.emailIndicatorTarget.classList.toggle('bg-green-500', isValid)
        this.emailIndicatorTarget.classList.toggle('bg-red-500', !isValid && email.length > 0)

        this.updateSubmitButton()
    }

    validatePassword(event) {
        const password = event.target.value
        const isValid = password.length >= 6

        this.passwordIndicatorTarget.classList.toggle('opacity-0', !isValid)
        this.passwordIndicatorTarget.classList.toggle('bg-green-500', isValid)
        this.passwordIndicatorTarget.classList.toggle('bg-red-500', !isValid && password.length > 0)

        this.updateSubmitButton()
    }

    updateSubmitButton() {
        const email = this.element.querySelector('#admin_user_email').value.trim()
        const password = this.element.querySelector('#admin_user_password').value
        const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && password.length >= 6

        this.submitBtnTarget.disabled = !isValid
    }
}