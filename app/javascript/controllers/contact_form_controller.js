import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "form", "title", "step1", "step2", 
    "firstName", "lastName", "email", "mobile", "description",
    "nextBtn", "backBtn", "submitBtn"
  ]

  connect() {
    console.log("Contact form controller connected")
    this.currentStep = 1
    this.showStep(1)
  }

  nextStep(event) {
    console.log("Next step clicked", event)
    event.preventDefault()
    if (this.validateStep1()) {
      console.log("Validation passed, moving to step 2")
      this.currentStep = 2
      this.showStep(2)
      this.updateTitle()
    } else {
      console.log("Validation failed")
    }
  }

  goBack() {
    this.currentStep = 1
    this.showStep(1)
    this.updateTitle()
  }

  validateStep1() {
    console.log("Validating step 1")
    const firstName = this.firstNameTarget.value.trim()
    const lastName = this.lastNameTarget.value.trim()
    const email = this.emailTarget.value.trim()

    console.log("Values:", { firstName, lastName, email })

    // Clear previous validation states
    this.clearValidationErrors()

    let isValid = true

    if (!firstName) {
      console.log("First name missing")
      this.showFieldError(this.firstNameTarget, "First name is required")
      isValid = false
    }

    if (!lastName) {
      console.log("Last name missing")
      this.showFieldError(this.lastNameTarget, "Last name is required")
      isValid = false
    }

    if (!email) {
      console.log("Email missing")
      this.showFieldError(this.emailTarget, "Email is required")
      isValid = false
    } else if (!this.isValidEmail(email)) {
      console.log("Email invalid")
      this.showFieldError(this.emailTarget, "Please enter a valid email address")
      isValid = false
    }

    console.log("Validation result:", isValid)
    return isValid
  }

  showStep(step) {
    if (step === 1) {
      this.step1Target.style.display = "block"
      this.step2Target.style.display = "none"
      this.nextBtnTarget.style.display = "inline-block"
      this.backBtnTarget.style.display = "none"
      this.submitBtnTarget.style.display = "none"
    } else {
      this.step1Target.style.display = "none"
      this.step2Target.style.display = "block"
      this.nextBtnTarget.style.display = "none"
      this.backBtnTarget.style.display = "inline-block"
      this.submitBtnTarget.style.display = "inline-block"
    }
  }

  updateTitle() {
    if (this.currentStep === 1) {
      this.titleTarget.textContent = "Get In Touch"
    } else {
      const firstName = this.firstNameTarget.value.trim()
      this.titleTarget.textContent = `Hi ${firstName}, tell us more`
    }
  }

  showFieldError(field, message) {
    field.classList.add("is-invalid")
    
    // Remove existing error message
    const existingError = field.parentNode.querySelector(".invalid-feedback")
    if (existingError) {
      existingError.remove()
    }

    // Add new error message
    const errorDiv = document.createElement("div")
    errorDiv.className = "invalid-feedback"
    errorDiv.textContent = message
    field.parentNode.appendChild(errorDiv)
  }

  clearValidationErrors() {
    const invalidFields = this.element.querySelectorAll(".is-invalid")
    invalidFields.forEach(field => {
      field.classList.remove("is-invalid")
    })

    const errorMessages = this.element.querySelectorAll(".invalid-feedback")
    errorMessages.forEach(error => {
      error.remove()
    })
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  // Reset form when modal is closed or controller disconnects
  disconnect() {
    this.resetForm()
  }

  resetForm() {
    console.log("Resetting form")
    this.currentStep = 1
    this.showStep(1)
    this.clearValidationErrors()
    if (this.hasFormTarget) {
      this.formTarget.reset()
    }
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = "Get In Touch"
    }
  }

  // Add method to handle modal events
  modalHidden() {
    this.resetForm()
  }
}
