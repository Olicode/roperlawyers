import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["comment", "moreLink", "lessLink"];

  connect() {
    // Set initial state: truncated comment, show "More", hide "Less"
    if (
      this.hasCommentTarget &&
      this.hasMoreLinkTarget &&
      this.hasLessLinkTarget
    ) {
      this.commentTarget.innerHTML = this.commentTarget.dataset.truncated;
      this.moreLinkTarget.classList.remove("d-none");
      this.lessLinkTarget.classList.add("d-none");
    }
  }

  showFull(event) {
    event.preventDefault();
    if (
      this.hasCommentTarget &&
      this.hasMoreLinkTarget &&
      this.hasLessLinkTarget
    ) {
      this.commentTarget.innerHTML = this.commentTarget.dataset.full;
      this.moreLinkTarget.classList.add("d-none");
      this.lessLinkTarget.classList.remove("d-none");
    }
  }

  showTruncated(event) {
    event.preventDefault();
    if (
      this.hasCommentTarget &&
      this.hasMoreLinkTarget &&
      this.hasLessLinkTarget
    ) {
      this.commentTarget.innerHTML = this.commentTarget.dataset.truncated;
      this.lessLinkTarget.classList.add("d-none");
      this.moreLinkTarget.classList.remove("d-none");
    }
  }
}
