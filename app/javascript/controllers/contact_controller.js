import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "successMessage", "errorMessage", "spinner"];

  connect() {
    // Hide messages and spinner on connect
    this.hideAll();
  }

  hideAll() {
    if (this.hasSuccessMessageTarget)
      this.successMessageTarget.style.display = "none";
    if (this.hasErrorMessageTarget)
      this.errorMessageTarget.style.display = "none";
    if (this.hasSpinnerTarget) this.spinnerTarget.style.display = "none";
  }

  submit(event) {
    event.preventDefault();
    this.hideAll();
    if (this.hasSpinnerTarget) this.spinnerTarget.style.display = "block";
    if (this.hasFormTarget)
      this.formTarget
        .querySelector("button[type=submit]")
        .setAttribute("disabled", "disabled");

    const formData = new FormData(this.formTarget);
    fetch(this.formTarget.action, {
      method: this.formTarget.method,
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          if (this.hasSuccessMessageTarget) {
            this.successMessageTarget.innerText =
              data.message || "Your message was sent!";
            this.successMessageTarget.style.display = "block";
          }
          this.formTarget.reset();
        } else {
          if (this.hasErrorMessageTarget) {
            this.errorMessageTarget.innerText =
              data.error || "There was an error.";
            this.errorMessageTarget.style.display = "block";
          }
        }
      })
      .catch(() => {
        if (this.hasErrorMessageTarget) {
          this.errorMessageTarget.innerText =
            "There was an error submitting the form.";
          this.errorMessageTarget.style.display = "block";
        }
      })
      .finally(() => {
        if (this.hasSpinnerTarget) this.spinnerTarget.style.display = "none";
        if (this.hasFormTarget)
          this.formTarget
            .querySelector("button[type=submit]")
            .removeAttribute("disabled");
      });
  }
}
