import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-form"
export default class extends Controller {
  static targets = [
    // NIE
    "nieNoRadio",
    "nieYesRadio",
    "nieFields",
    "parentFields",
    // Reservation/Utility/Account
    "payYes",
    "payNo",
    "resSection",
    "sameBox",
    "payFee",
    "contractFld",
    "balanceFld",
    "hasSpanishAccountYes",
    "hasSpanishAccountNo",
    "utilitySection",
    // File Upload
    "fileUploadInput",
    "fileUploadLabel",
    // Spouse Section
    "currentlyMarriedTrue",
    "currentlyMarriedFalse",
    "currentSpouseSection",
    "previouslyMarriedTrue",
    "previouslyMarriedFalse",
    "previousSpouseSection",
    // PoA Section
    "needsPoaYes",
    "needsPoaNo",
    "needsPoaAlready",
    "poaDetails",
    "poaSection",
    "servicePurchase",
    "serviceSale",
    "serviceNewBuild",
    // Section toggles
    "sectionPurchase",
    "sectionSale",
    "sectionNewBuild",
    "sectionWill",
    "sectionShortTerm",
    "sectionDocuments",
    // Service checkboxes
    "serviceVv",
    "serviceRegistry",
    "serviceActivities",
    "serviceWill",
    // Special sections
    "vvLicenseUploadSection",
    "civilLiabilitySection",
    "igicRegistrationSection",
    "waterBillSection",
    "electricityBillSection",
    // CEE/Title Deed radios and sections
    "ceeUploadNowRadio",
    "ceeSendLaterRadio",
    "ceeNeedToApplyRadio",
    "ceeUploadSection",
    "titleDeedUploadNowRadio",
    "titleDeedSendLaterRadio",
    "titleDeedCantFindRadio",
    "titleDeedUploadSection",
    // Date of birth
    "dateOfBirthField",
    "dateOfBirthError",
  ];

  connect() {
    // NIE toggle
    if (
      this.hasNieNoRadioTarget &&
      this.hasNieYesRadioTarget &&
      this.hasNieFieldsTarget &&
      this.hasParentFieldsTarget
    ) {
      this.nieNoRadioTarget.addEventListener(
        "change",
        this.toggleSections.bind(this)
      );
      this.nieYesRadioTarget.addEventListener(
        "change",
        this.toggleSections.bind(this)
      );
      this.nieFieldsTarget.classList.add("hidden-section");
      this.parentFieldsTarget.classList.add("hidden-section");
      if (this.nieNoRadioTarget.checked || this.nieYesRadioTarget.checked) {
        this.toggleSections();
      }
    }

    // Reservation/Utility/Account

    if (
      this.hasPayYesTarget &&
      this.hasPayNoTarget &&
      this.hasResSectionTarget &&
      this.hasSameBoxTarget &&
      this.hasPayFeeTarget &&
      this.hasContractFldTarget &&
      this.hasBalanceFldTarget &&
      this.hasHasSpanishAccountYesTarget &&
      this.hasHasSpanishAccountNoTarget &&
      this.hasUtilitySectionTarget
    ) {
      [this.payYesTarget, this.payNoTarget].forEach((rb) =>
        rb.addEventListener("change", this.toggleReservationSection.bind(this))
      );
      this.sameBoxTarget.addEventListener(
        "change",
        this.syncAccounts.bind(this)
      );
      [this.payFeeTarget, this.contractFldTarget].forEach((f) =>
        f.addEventListener("input", this.mirrorAccounts.bind(this))
      );
      this.hasSpanishAccountYesTarget.addEventListener("change", () => {
        this.toggleUtilitySection();
      });
      this.hasSpanishAccountNoTarget.addEventListener("change", () => {
        this.toggleUtilitySection();
      });
      this.toggleReservationSection();
      this.toggleUtilitySection();
    }

    // File Upload UI
    this.initializeFileUploads();

    // Spouse Sections
    if (
      this.hasCurrentlyMarriedTrueTarget &&
      this.hasCurrentlyMarriedFalseTarget &&
      this.hasCurrentSpouseSectionTarget &&
      this.hasPreviouslyMarriedTrueTarget &&
      this.hasPreviouslyMarriedFalseTarget &&
      this.hasPreviousSpouseSectionTarget
    ) {
      this.currentlyMarriedTrueTarget.addEventListener(
        "change",
        this.toggleSpouseSections.bind(this)
      );
      this.currentlyMarriedFalseTarget.addEventListener(
        "change",
        this.toggleSpouseSections.bind(this)
      );
      this.previouslyMarriedTrueTarget.addEventListener(
        "change",
        this.toggleSpouseSections.bind(this)
      );
      this.previouslyMarriedFalseTarget.addEventListener(
        "change",
        this.toggleSpouseSections.bind(this)
      );
      this.toggleSpouseSections();
    }

    // PoA Section
    if (
      this.hasNeedsPoaYesTarget &&
      this.hasNeedsPoaNoTarget &&
      this.hasNeedsPoaAlreadyTarget &&
      this.hasPoaDetailsTarget &&
      this.hasPoaSectionTarget &&
      this.hasServicePurchaseTarget &&
      this.hasServiceSaleTarget &&
      this.hasServiceNewBuildTarget &&
      this.hasNieYesRadioTarget
    ) {
      [
        this.needsPoaYesTarget,
        this.needsPoaNoTarget,
        this.needsPoaAlreadyTarget,
      ].forEach((radio) => {
        radio.addEventListener("change", this.togglePoaDetails.bind(this));
      });
      [
        this.servicePurchaseTarget,
        this.serviceSaleTarget,
        this.serviceNewBuildTarget,
      ].forEach((el) => {
        el.addEventListener(
          "change",
          this.updatePoaSectionVisibility.bind(this)
        );
      });
      // Listen to NIE Yes radio for PoA visibility
      if (this.hasNieYesRadioTarget) {
        this.nieYesRadioTarget.addEventListener(
          "change",
          this.updatePoaSectionVisibility.bind(this)
        );
      }
      // Also listen to NIE No if present
      const nieNoRadio = document.getElementById("needs_nie_no");
      if (nieNoRadio)
        nieNoRadio.addEventListener(
          "change",
          this.updatePoaSectionVisibility.bind(this)
        );
      this.togglePoaDetails();
      this.updatePoaSectionVisibility();
    }

    // --- Robustly attach listeners to all service checkboxes (singular and plural targets) ---
    const allServiceCheckboxes = [
      ...(this.servicePurchaseTargets || []),
      ...(this.serviceSaleTargets || []),
      ...(this.serviceNewBuildTargets || []),
      ...(this.serviceWillTargets || []),
      ...(this.serviceVvTargets || []),
      ...(this.serviceRegistryTargets || []),
      ...(this.serviceActivitiesTargets || []),
    ];
    [
      this.servicePurchaseTarget,
      this.serviceSaleTarget,
      this.serviceNewBuildTarget,
      this.serviceWillTarget,
      this.serviceVvTarget,
      this.serviceRegistryTarget,
      this.serviceActivitiesTarget,
    ].forEach((cb) => {
      if (cb && !allServiceCheckboxes.includes(cb))
        allServiceCheckboxes.push(cb);
    });
    allServiceCheckboxes.forEach((checkbox) => {
      checkbox.addEventListener("change", this.updateSections.bind(this));
    });
    this.updateSections();

    // CEE upload section toggle
    if (
      this.hasCeeUploadNowRadioTarget &&
      this.hasCeeSendLaterRadioTarget &&
      this.hasCeeNeedToApplyRadioTarget &&
      this.hasCeeUploadSectionTarget
    ) {
      [
        this.ceeUploadNowRadioTarget,
        this.ceeSendLaterRadioTarget,
        this.ceeNeedToApplyRadioTarget,
      ].forEach((radio) => {
        radio.addEventListener(
          "change",
          this.toggleCeeUploadSection.bind(this)
        );
      });
      this.toggleCeeUploadSection();
    }

    // Title Deed upload section toggle
    if (
      this.hasTitleDeedUploadNowRadioTarget &&
      this.hasTitleDeedSendLaterRadioTarget &&
      this.hasTitleDeedCantFindRadioTarget &&
      this.hasTitleDeedUploadSectionTarget
    ) {
      [
        this.titleDeedUploadNowRadioTarget,
        this.titleDeedSendLaterRadioTarget,
        this.titleDeedCantFindRadioTarget,
      ].forEach((radio) => {
        radio.addEventListener(
          "change",
          this.toggleTitleDeedUploadSection.bind(this)
        );
      });
      this.toggleTitleDeedUploadSection();
    }

    // Date of birth validation
    if (this.hasDateOfBirthFieldTarget && this.hasDateOfBirthErrorTarget) {
      this.dateOfBirthFieldTarget.addEventListener(
        "input",
        this.validateDateOfBirth.bind(this)
      );
    }
  }

  // NIE
  toggleSections() {
    if (this.nieNoRadioTarget.checked) {
      this.nieFieldsTarget.classList.remove("hidden-section");
    } else {
      this.nieFieldsTarget.classList.add("hidden-section");
    }
    if (this.nieYesRadioTarget.checked) {
      this.parentFieldsTarget.classList.remove("hidden-section");
    } else {
      this.parentFieldsTarget.classList.add("hidden-section");
    }
    // Ensure POA section visibility updates when NIE Yes is selected
    if (typeof this.updatePoaSectionVisibility === "function") {
      this.updatePoaSectionVisibility();
    }
  }

  // Reservation/Utility/Account
  toggleReservationSection() {
    this.resSectionTarget.style.display = this.payYesTarget.checked
      ? "block"
      : "none";
    this.syncAccounts();
  }

  toggleUtilitySection() {
    if (this.hasUtilitySectionTarget && this.hasHasSpanishAccountYesTarget) {
      this.utilitySectionTarget.style.display = this.hasSpanishAccountYesTarget
        .checked
        ? "block"
        : "none";
    }
  }

  syncAccounts() {
    if (!this.sameBoxTarget.checked) {
      [
        this.payFeeTarget,
        this.contractFldTarget,
        this.balanceFldTarget,
      ].forEach((f) => f.removeAttribute("readonly"));
      return;
    }
    if (this.payYesTarget.checked) {
      [this.contractFldTarget, this.balanceFldTarget].forEach((f) => {
        f.value = this.payFeeTarget.value;
        f.setAttribute("readonly", "readonly");
      });
    } else {
      this.balanceFldTarget.value = this.contractFldTarget.value;
      this.balanceFldTarget.setAttribute("readonly", "readonly");
      this.contractFldTarget.removeAttribute("readonly");
    }
  }

  mirrorAccounts(e) {
    if (!this.sameBoxTarget.checked) return;
    if (e.target === this.payFeeTarget && this.payYesTarget.checked) {
      [this.contractFldTarget, this.balanceFldTarget].forEach(
        (f) => (f.value = this.payFeeTarget.value)
      );
    } else if (
      e.target === this.contractFldTarget &&
      !this.payYesTarget.checked
    ) {
      this.balanceFldTarget.value = this.contractFldTarget.value;
    }
  }

  /**
   * Show/hide PoA details section based on radio selection.
   */
  togglePoaDetails() {
    if (this.hasPoaDetailsTarget && this.hasNeedsPoaYesTarget) {
      this.poaDetailsTarget.style.display = this.needsPoaYesTarget.checked
        ? "block"
        : "none";
    }
  }

  /**
   * Show/hide PoA main section based on NIE Yes or service checkboxes.
   */
  updatePoaSectionVisibility() {
    if (!this.hasPoaSectionTarget) return;
    const shouldShow =
      (this.hasNieYesRadioTarget && this.nieYesRadioTarget.checked) ||
      (this.hasServicePurchaseTarget && this.servicePurchaseTarget.checked) ||
      (this.hasServiceSaleTarget && this.serviceSaleTarget.checked) ||
      (this.hasServiceNewBuildTarget && this.serviceNewBuildTarget.checked);
    this.poaSectionTarget.style.display = shouldShow ? "block" : "none";
  }

  /**
   * Show/hide spouse sections based on radio selections.
   */
  toggleSpouseSections() {
    if (this.currentlyMarriedTrueTarget.checked) {
      this.currentSpouseSectionTarget.style.display = "block";
    } else {
      this.currentSpouseSectionTarget.style.display = "none";
    }
    if (this.previouslyMarriedTrueTarget.checked) {
      this.previousSpouseSectionTarget.style.display = "block";
    } else {
      this.previousSpouseSectionTarget.style.display = "none";
    }
  }

  /**
   * File upload UI enhancements: icon SVGs, label text, file list, drag & drop, delete, and syncing input files.
   * Applies to all fileUploadInputTargets and fileUploadLabelTargets.
   */
  initializeFileUploads() {
    // Replace upload icons with SVG if not already present
    this.fileUploadLabelTargets.forEach((label) => {
      const icon = label.querySelector(".upload-icon");
      if (icon && !icon.querySelector("svg")) {
        icon.innerHTML = `<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' class='feather feather-upload-cloud'><polyline points='16 16 12 12 8 16'></polyline><line x1='12' y1='12' x2='12' y2='21'></line><path d='M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3'></path><polyline points='16 16 12 12 8 16'></polyline></svg>`;
      }
      // Add upload-text and file-types spans if not already present
      if (!label.querySelector(".upload-text")) {
        const uploadText = document.createElement("span");
        uploadText.className = "upload-text";
        uploadText.textContent = "Upload a file or drag & drop";
        const fileTypes = document.createElement("span");
        fileTypes.className = "file-types";
        fileTypes.textContent = "PDF, JPG, PNG";
        const iconElement = label.querySelector(".upload-icon");
        if (iconElement) {
          iconElement.insertAdjacentElement("afterend", fileTypes);
          iconElement.insertAdjacentElement("afterend", uploadText);
        }
      }
    });

    // Enhance each file input
    this.fileUploadInputTargets.forEach((input) => {
      const label = input.closest(".file-upload-label");
      if (!label) return;
      // Only add file list once
      let fileList = label.querySelector(".file-list");
      if (!fileList) {
        fileList = document.createElement("div");
        fileList.className = "file-list mt-3 w-100";
        label.appendChild(fileList);
      }
      // Per-input file storage
      const storedFiles = new Map();
      // Helper to update the file list UI
      const updateFileList = () => {
        fileList.innerHTML = "";
        if (storedFiles.size === 0) {
          fileList.style.display = "none";
          return;
        }
        fileList.style.display = "block";
        storedFiles.forEach((file, id) => {
          const fileItem = document.createElement("div");
          fileItem.className =
            "file-item d-flex align-items-center justify-content-between bg-light rounded p-2 mb-2";
          fileItem.innerHTML = `
            <div class="d-flex align-items-center">
              <span class="me-2"><svg xmlns='http://www.w3.org/2000/svg' width='20' height='20' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' class='feather feather-file-text'><path d='M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z'></path><polyline points='14 2 14 8 20 8'></polyline></svg></span>
              <span class="file-name">${file.name}</span>
              <span class="badge bg-secondary ms-2">${
                file.type || "file"
              }</span>
            </div>
            <button type="button" class="btn btn-sm btn-outline-danger delete-file" data-file-id="${id}">Remove</button>
          `;
          fileList.appendChild(fileItem);
        });
        fileList.querySelectorAll(".delete-file").forEach((btn) => {
          btn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();
            const fileId = this.getAttribute("data-file-id");
            storedFiles.delete(fileId);
            updateFileList();
            updateInputFiles();
          });
        });
      };
      // Helper to sync files to the input
      const updateInputFiles = () => {
        const dataTransfer = new DataTransfer();
        storedFiles.forEach((file) => {
          dataTransfer.items.add(file);
        });
        input.files = dataTransfer.files;
      };
      // Handle file input change
      input.addEventListener("change", function () {
        if (this.files.length > 0) {
          for (let i = 0; i < this.files.length; i++) {
            const file = this.files[i];
            const id =
              Date.now() + "-" + Math.random().toString(36).substr(2, 9);
            storedFiles.set(id, file);
          }
          this.value = "";
          updateFileList();
          updateInputFiles();
        }
      });
      // Drag & drop handlers
      label.addEventListener("dragover", function (e) {
        e.preventDefault();
        label.classList.add("dragover");
      });
      label.addEventListener("dragleave", function () {
        label.classList.remove("dragover");
      });
      label.addEventListener("drop", function (e) {
        e.preventDefault();
        label.classList.remove("dragover");
        if (e.dataTransfer.files.length) {
          for (let i = 0; i < e.dataTransfer.files.length; i++) {
            const file = e.dataTransfer.files[i];
            const id =
              Date.now() + "-" + Math.random().toString(36).substr(2, 9);
            storedFiles.set(id, file);
          }
          updateFileList();
          updateInputFiles();
        }
      });
      // Initialize
      updateFileList();
    });
  }

  // Section toggling logic (property, will, short term, documents, etc)
  updateSections() {
    // Show/hide Purchase section (robust for single/plural targets)
    if (
      this.hasSectionPurchaseTarget &&
      (this.hasServicePurchaseTargets || this.hasServicePurchaseTarget)
    ) {
      const purchaseCheckboxes = this.servicePurchaseTargets?.length
        ? this.servicePurchaseTargets
        : this.servicePurchaseTarget
        ? [this.servicePurchaseTarget]
        : [];
      const checked = purchaseCheckboxes.some((cb) => cb.checked);
      this.sectionPurchaseTarget.style.display = checked ? "block" : "none";
    }
    // Show/hide Sale section
    if (
      this.hasSectionSaleTarget &&
      (this.hasServiceSaleTargets || this.hasServiceSaleTarget)
    ) {
      const saleCheckboxes = this.serviceSaleTargets?.length
        ? this.serviceSaleTargets
        : this.serviceSaleTarget
        ? [this.serviceSaleTarget]
        : [];
      const checked = saleCheckboxes.some((cb) => cb.checked);
      this.sectionSaleTarget.style.display = checked ? "block" : "none";
    }
    // Show/hide New Build section
    if (
      this.hasSectionNewBuildTarget &&
      (this.hasServiceNewBuildTargets || this.hasServiceNewBuildTarget)
    ) {
      const newBuildCheckboxes = this.serviceNewBuildTargets?.length
        ? this.serviceNewBuildTargets
        : this.serviceNewBuildTarget
        ? [this.serviceNewBuildTarget]
        : [];
      const checked = newBuildCheckboxes.some((cb) => cb.checked);
      this.sectionNewBuildTarget.style.display = checked ? "block" : "none";
    }
    // Show/hide Will section
    if (
      this.hasSectionWillTarget &&
      (this.hasServiceWillTargets || this.hasServiceWillTarget)
    ) {
      const willCheckboxes = this.serviceWillTargets?.length
        ? this.serviceWillTargets
        : this.serviceWillTarget
        ? [this.serviceWillTarget]
        : [];
      const checked = willCheckboxes.some((cb) => cb.checked);
      this.sectionWillTarget.style.display = checked ? "block" : "none";
    }
    // Show/hide Short Term section if any related service is checked (supports multiple checkboxes)
    if (
      this.hasSectionShortTermTarget &&
      this.hasServiceVvTargets &&
      this.hasServiceRegistryTargets &&
      this.hasServiceActivitiesTargets
    ) {
      const checked =
        this.serviceVvTargets.some((cb) => cb.checked) ||
        this.serviceRegistryTargets.some((cb) => cb.checked) ||
        this.serviceActivitiesTargets.some((cb) => cb.checked);
      this.sectionShortTermTarget.style.display = checked ? "block" : "none";
    }
    // Show/hide Documents section (sale or short-term compliance, supports multiple checkboxes)
    if (
      this.hasSectionDocumentsTarget &&
      (this.hasServiceSaleTargets || this.hasServiceSaleTarget) &&
      (this.hasServiceVvTargets || this.hasServiceVvTarget) &&
      (this.hasServiceRegistryTargets || this.hasServiceRegistryTarget) &&
      (this.hasServiceActivitiesTargets || this.hasServiceActivitiesTarget)
    ) {
      const saleCheckboxes = this.serviceSaleTargets?.length
        ? this.serviceSaleTargets
        : this.serviceSaleTarget
        ? [this.serviceSaleTarget]
        : [];
      const vvCheckboxes = this.serviceVvTargets?.length
        ? this.serviceVvTargets
        : this.serviceVvTarget
        ? [this.serviceVvTarget]
        : [];
      const registryCheckboxes = this.serviceRegistryTargets?.length
        ? this.serviceRegistryTargets
        : this.serviceRegistryTarget
        ? [this.serviceRegistryTarget]
        : [];
      const activitiesCheckboxes = this.serviceActivitiesTargets?.length
        ? this.serviceActivitiesTargets
        : this.serviceActivitiesTarget
        ? [this.serviceActivitiesTarget]
        : [];

      const checked =
        saleCheckboxes.some((cb) => cb.checked) ||
        vvCheckboxes.some((cb) => cb.checked) ||
        registryCheckboxes.some((cb) => cb.checked) ||
        activitiesCheckboxes.some((cb) => cb.checked);

      this.sectionDocumentsTarget.style.display = checked ? "block" : "none";
    }
    // VV License upload: show only if Registry or Activities is selected and NOT VV License (supports multiple checkboxes)
    if (
      this.hasVvLicenseUploadSectionTarget &&
      this.hasServiceRegistryTargets &&
      this.hasServiceActivitiesTargets &&
      this.hasServiceVvTargets
    ) {
      const registryOrActivitiesChecked =
        this.serviceRegistryTargets.some((cb) => cb.checked) ||
        this.serviceActivitiesTargets.some((cb) => cb.checked);
      const vvChecked = this.serviceVvTargets.some((cb) => cb.checked);
      this.vvLicenseUploadSectionTarget.style.display =
        registryOrActivitiesChecked && !vvChecked ? "block" : "none";
    }
    // Civil Liability and IGIC: hide when only selling (show for holiday lets, supports multiple checkboxes)
    const isOnlySelling =
      this.hasServiceSaleTargets &&
      this.serviceSaleTargets.some((cb) => cb.checked) &&
      !(
        this.hasServiceVvTargets &&
        this.serviceVvTargets.some((cb) => cb.checked)
      ) &&
      !(
        this.hasServiceRegistryTargets &&
        this.serviceRegistryTargets.some((cb) => cb.checked)
      ) &&
      !(
        this.hasServiceActivitiesTargets &&
        this.serviceActivitiesTargets.some((cb) => cb.checked)
      );
    if (this.hasCivilLiabilitySectionTarget) {
      this.civilLiabilitySectionTarget.style.display = isOnlySelling
        ? "none"
        : "block";
    }
    if (this.hasIgicRegistrationSectionTarget) {
      this.igicRegistrationSectionTarget.style.display = isOnlySelling
        ? "none"
        : "block";
    }
    // Water/Electricity Bills: only when selling (supports single or multiple checkboxes)
    if (
      this.hasWaterBillSectionTarget &&
      (this.hasServiceSaleTargets || this.hasServiceSaleTarget)
    ) {
      const saleCheckboxes = this.serviceSaleTargets?.length
        ? this.serviceSaleTargets
        : this.serviceSaleTarget
        ? [this.serviceSaleTarget]
        : [];
      const checked = saleCheckboxes.some((cb) => cb.checked);
      this.waterBillSectionTarget.style.display = checked ? "block" : "none";
    }
    if (
      this.hasElectricityBillSectionTarget &&
      (this.hasServiceSaleTargets || this.hasServiceSaleTarget)
    ) {
      const saleCheckboxes = this.serviceSaleTargets?.length
        ? this.serviceSaleTargets
        : this.serviceSaleTarget
        ? [this.serviceSaleTarget]
        : [];
      const checked = saleCheckboxes.some((cb) => cb.checked);
      this.electricityBillSectionTarget.style.display = checked
        ? "block"
        : "none";
    }
  }

  // CEE upload section toggle
  toggleCeeUploadSection() {
    if (this.hasCeeUploadSectionTarget && this.hasCeeUploadNowRadioTarget) {
      this.ceeUploadSectionTarget.style.display = this.ceeUploadNowRadioTarget
        .checked
        ? "block"
        : "none";
    }
  }

  // Title Deed upload section toggle
  toggleTitleDeedUploadSection() {
    if (
      this.hasTitleDeedUploadSectionTarget &&
      this.hasTitleDeedUploadNowRadioTarget
    ) {
      this.titleDeedUploadSectionTarget.style.display = this
        .titleDeedUploadNowRadioTarget.checked
        ? "block"
        : "none";
    }
  }

  // Date of birth validation
  validateDateOfBirth() {
    if (!(this.hasDateOfBirthFieldTarget && this.hasDateOfBirthErrorTarget))
      return;
    const inputDate = this.dateOfBirthFieldTarget.value;
    const isValidFormat = this.dateOfBirthFieldTarget.checkValidity();
    if (isValidFormat) {
      const dateParts = inputDate.split("-");
      const year = parseInt(dateParts[0]);
      const month = parseInt(dateParts[1]);
      const day = parseInt(dateParts[2]);
      if (
        year >= 1900 &&
        year <= 2020 &&
        month >= 1 &&
        month <= 12 &&
        day >= 1 &&
        day <= 31
      ) {
        this.dateOfBirthErrorTarget.textContent = "";
      } else {
        this.dateOfBirthErrorTarget.textContent =
          "Invalid date. Please choose a valid date for your date of birth!";
      }
    } else {
      this.dateOfBirthErrorTarget.textContent =
        "Please use the format YYYY-MM-DD.";
    }
  }
}
