import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    scrollFallback: { type: Number, default: 320 },
  };

  connect() {
    this.heroTrigger = this.findHeroTrigger();
    this.mobileQuery = window.matchMedia("(max-width: 991.98px)");
    this.onScroll = () => this.updateVisibility();
    this.onBreakpointChange = () => this.updateVisibility();

    this.mobileQuery.addEventListener("change", this.onBreakpointChange);
    window.addEventListener("scroll", this.onScroll, { passive: true });
    window.addEventListener("resize", this.onScroll, { passive: true });

    this.updateVisibility();
  }

  disconnect() {
    this.mobileQuery.removeEventListener("change", this.onBreakpointChange);
    window.removeEventListener("scroll", this.onScroll);
    window.removeEventListener("resize", this.onScroll);
    document.body.classList.remove("mobile-sticky-cta-active");
  }

  findHeroTrigger() {
    return (
      document.querySelector(".hero-avatar-btn") ||
      document.querySelector(".hero-section") ||
      document.querySelector(".page-hero") ||
      document.querySelector("main h1")
    );
  }

  shouldShow() {
    if (!this.mobileQuery.matches) return false;

    const trigger = this.heroTrigger;
    if (!trigger) return window.scrollY > this.scrollFallbackValue;

    const rect = trigger.getBoundingClientRect();
    const isAvatarButton = trigger.classList.contains("hero-avatar-btn");

    if (isAvatarButton) {
      return rect.top < 0;
    }

    return rect.bottom < 0 || window.scrollY > this.scrollFallbackValue;
  }

  updateVisibility() {
    const visible = this.shouldShow();
    this.element.classList.toggle("is-visible", visible);
    this.element.setAttribute("aria-hidden", visible ? "false" : "true");
    document.body.classList.toggle("mobile-sticky-cta-active", visible);
  }
}
