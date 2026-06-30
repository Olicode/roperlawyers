import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["body", "text", "moreLink", "lessLink"];
  static values = { fullText: String };

  connect() {
    if (!this.hasBodyTarget || !this.hasTextTarget) return;

    this.expanded = false;
    this.collapse();
  }

  showFull(event) {
    event.preventDefault();
    this.expanded = true;
    this.bodyTarget.classList.remove("review-comment-clamped");
    this.textTarget.textContent = this.fullTextValue;

    if (this.hasMoreLinkTarget) this.moreLinkTarget.classList.add("d-none");
    if (this.hasLessLinkTarget) this.lessLinkTarget.classList.remove("d-none");
  }

  showTruncated(event) {
    event.preventDefault();
    this.expanded = false;
    this.collapse();
  }

  collapse() {
    this.bodyTarget.classList.add("review-comment-clamped");
    this.textTarget.textContent = this.fullTextValue;

    if (this.hasLessLinkTarget) this.lessLinkTarget.classList.add("d-none");
    if (this.hasMoreLinkTarget) this.moreLinkTarget.classList.add("d-none");

    requestAnimationFrame(() => this.applyTruncation());
  }

  applyTruncation() {
    const fullText = this.fullTextValue;
    const body = this.bodyTarget;

    body.classList.add("review-comment-clamped");
    this.textTarget.textContent = fullText;

    if (body.scrollHeight <= body.clientHeight + 1) return;

    if (this.hasMoreLinkTarget) this.moreLinkTarget.classList.remove("d-none");

    let low = 0;
    let high = fullText.length;

    while (low < high) {
      const mid = Math.ceil((low + high) / 2);
      this.textTarget.textContent = `${fullText.slice(0, mid).trimEnd()}...`;

      if (body.scrollHeight > body.clientHeight + 1) {
        high = mid - 1;
      } else {
        low = mid;
      }
    }

    this.textTarget.textContent = `${fullText.slice(0, low).trimEnd()}...`;
  }
}
