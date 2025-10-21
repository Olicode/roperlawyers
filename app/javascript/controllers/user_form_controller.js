import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-form"
export default class extends Controller {
  static targets = [
    // NIE
    "nieNoRadio",
    "nieYesRadio",
    "nieFields",
    "parentFields",
    // Bank Details Section
    "payYes",
    "payNo",
    "sameBox",
    "reservationDepositAccount",
    "privateContractAccount", 
    "remainingBalanceAccount",
    "hasSpanishAccountYes",
    "hasSpanishAccountNo",
    "rOriginBankDetails",
    // File Upload
    "fileUploadInput",
    "fileUploadLabel",
    // Spouse Section
    "currentlyMarriedTrue",
    "currentlyMarriedFalse",
    "previouslyMarriedTrue",
    "previouslyMarriedFalse",
    // Title Deed Section
    "canProvideTitleDeedUploadNow",
    "canProvideTitleDeedSendLater",
    "canProvideTitleDeedCantFind",
    // CEE Section
    "energyEfficiencyCertificateCeeProvided",
    "energyEfficiencyCertificateCeeClientWillProvide",
    "energyEfficiencyCertificateCeeWeNeedToApply",
    // PoA Section
    "needsPoaYes",
    "needsPoaNo",
    "needsPoaAlready",
    "poaSection",
    "poaFor",
    "poaMadeInSpain",
    // Conditional field targets
    "standingOrdersBankDetails",
    "nieNumber",
    "nieDocument",
    "fatherSFirstName",
    "motherSFirstName",
    "nameOfThePresentSpouse",
    "nameOfThePreviousSpouses",
    "dateOfDivorce",
    "dateOfDecease",
    "titleDeedDocuments",
    "ceeDocuments",
    // Service checkboxes
    "servicePurchase",
    "serviceSale",
    "serviceNewBuild",
    "serviceVv",
    "serviceRegistry",
    "serviceActivities",
    "serviceWill",
    "serviceDonation",
    // Section toggles
    "sectionPurchase",
    "sectionSale",
    "sectionNewBuild",
    "sectionWill",
    "sectionShortTerm",
    "sectionDocuments",
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
    // Document fields that conditionally show/hide
    "firstOccupationLicenseField",
    "municipalCertificateField",
    "floorPlanField",
    "communityApprovalField",
  ];

  connect() {
    // Set up generic conditional field listeners
    this.setupConditionalFields();
    
    // NIE toggle
    if (
      this.hasNieNoRadioTarget &&
      this.hasNieYesRadioTarget
    ) {
      this.nieNoRadioTarget.addEventListener(
        "change",
        this.toggleSections.bind(this)
      );
      this.nieYesRadioTarget.addEventListener(
        "change",
        this.toggleSections.bind(this)
      );
      // Hide all conditional NIE fields by default (they're already hidden with display: none from Rails)
      // No need to add hidden-section class since we're using display style now
      if (this.nieNoRadioTarget.checked || this.nieYesRadioTarget.checked) {
        this.toggleSections();
      }
    }

    // Bank Details Section
    if (
      this.hasPayYesTarget &&
      this.hasPayNoTarget
    ) {
      [this.payYesTarget, this.payNoTarget].forEach((rb) =>
        rb.addEventListener("change", this.toggleReservationDepositAccount.bind(this))
      );
      this.toggleReservationDepositAccount();
    }

    // Set up bank account sync - but delay to allow sections to be shown first
    setTimeout(() => {
      this.setupBankAccountSync();
    }, 100);

    if (
      this.hasHasSpanishAccountYesTarget &&
      this.hasHasSpanishAccountNoTarget
    ) {
      this.hasSpanishAccountYesTarget.addEventListener("change", () => {
        this.toggleUtilitySection();
      });
      this.hasSpanishAccountNoTarget.addEventListener("change", () => {
        this.toggleUtilitySection();
      });
      this.toggleUtilitySection();
    }

    // File Upload UI
    this.initializeFileUploads();

    // Spouse Sections
    if (
      this.hasCurrentlyMarriedTrueTarget &&
      this.hasCurrentlyMarriedFalseTarget &&
      this.hasPreviouslyMarriedTrueTarget &&
      this.hasPreviouslyMarriedFalseTarget
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

    // Title Deed Section
    if (
      this.hasCanProvideTitleDeedUploadNowTarget &&
      this.hasCanProvideTitleDeedSendLaterTarget &&
      this.hasCanProvideTitleDeedCantFindTarget
    ) {
      this.canProvideTitleDeedUploadNowTarget.addEventListener(
        "change",
        this.toggleTitleDeedUpload.bind(this)
      );
      this.canProvideTitleDeedSendLaterTarget.addEventListener(
        "change",
        this.toggleTitleDeedUpload.bind(this)
      );
      this.canProvideTitleDeedCantFindTarget.addEventListener(
        "change",
        this.toggleTitleDeedUpload.bind(this)
      );
      this.toggleTitleDeedUpload();
    }

    // CEE Section
    if (
      this.hasEnergyEfficiencyCertificateCeeProvidedTarget &&
      this.hasEnergyEfficiencyCertificateCeeClientWillProvideTarget &&
      this.hasEnergyEfficiencyCertificateCeeWeNeedToApplyTarget
    ) {
      this.energyEfficiencyCertificateCeeProvidedTarget.addEventListener(
        "change",
        this.toggleCeeUpload.bind(this)
      );
      this.energyEfficiencyCertificateCeeClientWillProvideTarget.addEventListener(
        "change",
        this.toggleCeeUpload.bind(this)
      );
      this.energyEfficiencyCertificateCeeWeNeedToApplyTarget.addEventListener(
        "change",
        this.toggleCeeUpload.bind(this)
      );
      this.toggleCeeUpload();
    }

    // PoA Section
    if (
      this.hasNeedsPoaYesTarget &&
      this.hasNeedsPoaNoTarget &&
      this.hasNeedsPoaAlreadyTarget &&
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
        this.serviceWillTarget,
        this.serviceDonationTarget,
        this.serviceVvTarget,
        this.serviceRegistryTarget,
        this.serviceActivitiesTarget,
      ].forEach((el) => {
        if (el) {
          el.addEventListener(
            "change",
            this.updatePoaSectionVisibility.bind(this)
          );
        }
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
      ...(this.serviceDonationTargets || []),
      ...(this.serviceVvTargets || []),
      ...(this.serviceRegistryTargets || []),
      ...(this.serviceActivitiesTargets || []),
    ];
    [
      this.servicePurchaseTarget,
      this.serviceSaleTarget,
      this.serviceNewBuildTarget,
      this.serviceWillTarget,
      this.serviceDonationTarget,
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
  }

  // NIE
  toggleSections() {
    const nieNoVisible = this.nieNoRadioTarget.checked;
    const nieYesVisible = this.nieYesRadioTarget.checked;
    
    // Toggle NIE number and document fields (when "No" is selected)
    if (this.hasNieNumberTarget) {
      this.animateToggle(this.nieNumberTarget, nieNoVisible);
    }
    
    if (this.hasNieDocumentTarget) {
      this.animateToggle(this.nieDocumentTarget, nieNoVisible);
    }

    // Toggle parent name fields (when "Yes" is selected) - grouped field
    if (this.hasFatherSFirstNameTarget) {
      this.animateToggle(this.fatherSFirstNameTarget, nieYesVisible);
    }

    // Ensure POA section visibility updates when NIE Yes is selected
    if (typeof this.updatePoaSectionVisibility === "function") {
      this.updatePoaSectionVisibility();
    }
  }


  /**
   * Show/hide PoA details section based on radio selection.
   */
  togglePoaDetails() {
    const isVisible = this.needsPoaYesTarget.checked;
    
    // Toggle POA conditional fields using Stimulus targets
    if (this.hasPoaForTarget) {
      this.animateToggle(this.poaForTarget, isVisible);
    }
    
    if (this.hasPoaMadeInSpainTarget) {
      this.animateToggle(this.poaMadeInSpainTarget, isVisible);
    }
  }

  /**
   * Show/hide PoA main section. Show always except when ONLY Will & Last Testament is selected.
   */
  updatePoaSectionVisibility() {
    if (!this.hasPoaSectionTarget) return;
    
    // Check which services are selected
    const purchaseChecked = this.hasServicePurchaseTarget && this.servicePurchaseTarget.checked;
    const saleChecked = this.hasServiceSaleTarget && this.serviceSaleTarget.checked;
    const newBuildChecked = this.hasServiceNewBuildTarget && this.serviceNewBuildTarget.checked;
    const willChecked = this.hasServiceWillTarget && this.serviceWillTarget.checked;
    const donationChecked = this.hasServiceDonationTarget && this.serviceDonationTarget.checked;
    const vvChecked = this.hasServiceVvTarget && this.serviceVvTarget.checked;
    const registryChecked = this.hasServiceRegistryTarget && this.serviceRegistryTarget.checked;
    const activitiesChecked = this.hasServiceActivitiesTarget && this.serviceActivitiesTarget.checked;
    
    // Check if ANY service other than Will is selected
    const otherServicesChecked = purchaseChecked || saleChecked || newBuildChecked || 
                                  donationChecked || vvChecked || registryChecked || activitiesChecked;
    
    // Hide ONLY if Will is the only service selected
    const shouldHide = willChecked && !otherServicesChecked;
    
    this.poaSectionTarget.style.display = shouldHide ? "none" : "block";
  }

  /**
   * Show/hide spouse sections based on radio selections.
   */
  toggleSpouseSections() {
    // Toggle current spouse field (when "Yes" is selected for currently married)
    const currentSpouseVisible = this.currentlyMarriedTrueTarget.checked;
    if (this.hasNameOfThePresentSpouseTarget) {
      this.animateToggle(this.nameOfThePresentSpouseTarget, currentSpouseVisible);
    }

    // Toggle previous spouse fields (when "Yes" is selected for previously married)
    const previousSpouseVisible = this.previouslyMarriedTrueTarget.checked;
    if (this.hasNameOfThePreviousSpousesTarget) {
      this.animateToggle(this.nameOfThePreviousSpousesTarget, previousSpouseVisible);
    }
    if (this.hasDateOfDivorceTarget) {
      this.animateToggle(this.dateOfDivorceTarget, previousSpouseVisible);
    }
    if (this.hasDateOfDeceaseTarget) {
      this.animateToggle(this.dateOfDeceaseTarget, previousSpouseVisible);
    }

    // Keep legacy section toggles for backward compatibility
    if (this.hasCurrentSpouseSectionTarget) {
      this.animateToggle(this.currentSpouseSectionTarget, currentSpouseVisible);
    }
    if (this.hasPreviousSpouseSectionTarget) {
      this.animateToggle(this.previousSpouseSectionTarget, previousSpouseVisible);
    }
  }

  /**
   * Show/hide title deed upload section based on radio selection.
   */
  toggleTitleDeedUpload() {
    const uploadVisible = this.canProvideTitleDeedUploadNowTarget.checked;
    if (this.hasTitleDeedDocumentsTarget) {
      this.animateToggle(this.titleDeedDocumentsTarget, uploadVisible);
    }
  }

  /**
   * Show/hide CEE upload section based on radio selection.
   */
  toggleCeeUpload() {
    const uploadVisible = this.energyEfficiencyCertificateCeeProvidedTarget.checked;
    if (this.hasCeeDocumentsTarget) {
      this.animateToggle(this.ceeDocumentsTarget, uploadVisible);
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
        e.stopPropagation();
        label.classList.add("dragover");
      });
      label.addEventListener("dragenter", function (e) {
        e.preventDefault();
        e.stopPropagation();
        label.classList.add("dragover");
      });
      label.addEventListener("dragleave", function (e) {
        e.preventDefault();
        e.stopPropagation();
        // Only remove dragover if we're leaving the label itself, not a child element
        if (!label.contains(e.relatedTarget)) {
          label.classList.remove("dragover");
        }
      });
      label.addEventListener("drop", function (e) {
        e.preventDefault();
        e.stopPropagation();
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

    // Show/hide Short Term section if any related service is checked
    if (this.hasSectionShortTermTarget) {
      const checked =
        (this.hasServiceVvTarget && this.serviceVvTarget.checked) ||
        (this.hasServiceRegistryTarget && this.serviceRegistryTarget.checked) ||
        (this.hasServiceActivitiesTarget && this.serviceActivitiesTarget.checked);
      this.sectionShortTermTarget.style.display = checked ? "block" : "none";
    }

    // Show/hide Documents section (sale or short-term compliance)
    if (this.hasSectionDocumentsTarget) {
      const checked =
        (this.hasServiceSaleTarget && this.serviceSaleTarget.checked) ||
        (this.hasServiceVvTarget && this.serviceVvTarget.checked) ||
        (this.hasServiceRegistryTarget && this.serviceRegistryTarget.checked) ||
        (this.hasServiceActivitiesTarget && this.serviceActivitiesTarget.checked);

      this.sectionDocumentsTarget.style.display = checked ? "block" : "none";
    }

    // VV License upload: show only if Registry or Activities is selected and NOT VV License (supports multiple checkboxes)
    if (this.hasVvLicenseUploadSectionTarget) {
      const registryOrActivitiesChecked =
        this.serviceRegistryTarget.checked ||
        this.serviceActivitiesTarget.checked;
      const vvChecked = this.serviceVvTarget.checked;
      this.vvLicenseUploadSectionTarget.style.display =
        registryOrActivitiesChecked && !vvChecked ? "block" : "none";
    }

    // Civil Liability and IGIC: hide when only selling (show for holiday lets)
    const isOnlySelling =
      this.hasServiceSaleTarget &&
      this.serviceSaleTarget.checked &&
      !(this.hasServiceVvTarget && this.serviceVvTarget.checked) &&
      !(this.hasServiceRegistryTarget && this.serviceRegistryTarget.checked) &&
      !(this.hasServiceActivitiesTarget && this.serviceActivitiesTarget.checked);
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
    
    // Water/Electricity Bills: Show for both Sale and VV Licence
    // (Previously these were hidden for Sale, now they show for both)
    
    // Hide certain fields when ONLY selling (not for VV Licence)
    if (this.hasFirstOccupationLicenseFieldTarget) {
      this.firstOccupationLicenseFieldTarget.style.display = isOnlySelling ? "none" : "block";
    }
    if (this.hasMunicipalCertificateFieldTarget) {
      this.municipalCertificateFieldTarget.style.display = isOnlySelling ? "none" : "block";
    }
    if (this.hasFloorPlanFieldTarget) {
      this.floorPlanFieldTarget.style.display = isOnlySelling ? "none" : "block";
    }
    if (this.hasCommunityApprovalFieldTarget) {
      this.communityApprovalFieldTarget.style.display = isOnlySelling ? "none" : "block";
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

  // Bank Details Section Toggle Methods
  toggleReservationDepositAccount() {
    if (!this.hasROriginBankDetailsTarget) return;
    
    const shouldShow = this.hasPayYesTarget && this.payYesTarget.checked;
    this.animateToggle(this.rOriginBankDetailsTarget, shouldShow);
  }

  toggleUtilitySection() {
    if (!this.hasStandingOrdersBankDetailsTarget) return;
    
    const shouldShow = this.hasHasSpanishAccountYesTarget && this.hasSpanishAccountYesTarget.checked;
    this.animateToggle(this.standingOrdersBankDetailsTarget, shouldShow);
  }

  syncAccounts() {
    if (!this.hasSameBoxTarget) {
      return;
    }
    
    const checkbox = this.sameBoxTarget.querySelector('input[type="checkbox"]');
    const shouldSync = checkbox ? checkbox.checked : false;
    
    if (shouldSync) {
      // Copy reservation deposit account to private contract and remaining balance
      if (this.hasReservationDepositAccountTarget && this.hasPrivateContractAccountTarget) {
        const reservationValue = this.reservationDepositAccountTarget.value || '';
        const contractInput = this.privateContractAccountTarget;
        if (contractInput) contractInput.value = reservationValue;
      }
      
      if (this.hasReservationDepositAccountTarget && this.hasRemainingBalanceAccountTarget) {
        const reservationValue = this.reservationDepositAccountTarget.value || '';
        const balanceInput = this.remainingBalanceAccountTarget;
        if (balanceInput) balanceInput.value = reservationValue;
      }
    }
  }

  setupBankAccountSync() {
    if (
      this.hasSameBoxTarget &&
      this.hasPrivateContractAccountTarget &&
      this.hasRemainingBalanceAccountTarget
    ) {
      
      const checkbox = this.sameBoxTarget.querySelector('input[type="checkbox"]');
      if (checkbox) {
        checkbox.addEventListener(
          "change",
          this.syncAccounts.bind(this)
        );
      }
      
      // Attach input listeners to the actual input fields within the targets
      const contractInput = this.privateContractAccountTarget;
      const balanceInput = this.remainingBalanceAccountTarget;
      const reservationInput = this.rOriginBankDetailsTarget?.querySelector('input');
      
      if (contractInput) {
        contractInput.addEventListener("input", this.mirrorAccounts.bind(this));
      }
      if (balanceInput) {
        balanceInput.addEventListener("input", this.mirrorAccounts.bind(this));
      }
      
      // Also listen to reservation input changes for mirroring
      if (reservationInput) {
        reservationInput.addEventListener("input", this.mirrorAccounts.bind(this));
      }
    }
  }

  mirrorAccounts() {
    const checkbox = this.sameBoxTarget?.querySelector('input[type="checkbox"]');
    if (!this.hasSameBoxTarget || !checkbox || !checkbox.checked) {
      return;
    }
    
    // Mirror the reservation deposit account value to other fields when they change
    this.syncAccounts();
  }

  /**
   * Animate toggle helper - smooth show/hide with transitions
   */
  animateToggle(element, shouldShow) {
    if (!element) return;
    
    // Add transition if not already present
    if (!element.style.transition) {
      element.style.transition = 'opacity 0.3s ease, max-height 0.3s ease';
      element.style.overflow = 'hidden';
    }
    
    if (shouldShow) {
      // Show with animation
      element.style.display = 'block';
      element.style.maxHeight = '0px';
      element.style.opacity = '0';
      
      // Force reflow
      element.offsetHeight;
      
      // Animate in
      setTimeout(() => {
        element.style.maxHeight = '2000px';
        element.style.opacity = '1';
      }, 10);
    } else {
      // Hide with animation
      element.style.maxHeight = '0px';
      element.style.opacity = '0';
      
      setTimeout(() => {
        element.style.display = 'none';
      }, 300);
    }
  }

  /**
   * Set up generic conditional field display based on data attributes
   */
  setupConditionalFields() {
    // Find all elements with data-condition-field attribute
    const conditionalFields = this.element.querySelectorAll('[data-condition-field]');
    
    conditionalFields.forEach(conditionalField => {
      const conditionFieldName = conditionalField.getAttribute('data-condition-field');
      const conditionValue = conditionalField.getAttribute('data-condition-value');
      
      // Add transition styles
      conditionalField.style.transition = 'opacity 0.3s ease, max-height 0.3s ease';
      conditionalField.style.overflow = 'hidden';
      
      // Find the condition field (checkbox, radio, or select)
      const conditionInput = this.element.querySelector(`#user_${conditionFieldName}`);
      
      if (conditionInput) {
        // Set up the toggle function
        const toggleConditionalField = () => {
          let shouldShow = false;
          
          // Handle different input types
          if (conditionInput.type === 'checkbox') {
            const isChecked = conditionInput.checked;
            shouldShow = (conditionValue === 'true' && isChecked) || 
                        (conditionValue === 'false' && !isChecked);
          } else if (conditionInput.tagName === 'SELECT' || conditionInput.type === 'select-one') {
            // For select dropdowns
            shouldShow = conditionInput.value === conditionValue;
          } else if (conditionInput.type === 'radio') {
            // For radio buttons, need to check if any radio with this name is selected with the value
            const radioGroup = this.element.querySelectorAll(`input[name="${conditionInput.name}"]`);
            radioGroup.forEach(radio => {
              if (radio.checked && radio.value === conditionValue) {
                shouldShow = true;
              }
            });
          }
          
          if (shouldShow) {
            // Show with animation
            conditionalField.style.display = 'block';
            conditionalField.style.maxHeight = '0px';
            conditionalField.style.opacity = '0';
            
            // Force reflow
            conditionalField.offsetHeight;
            
            // Animate in
            setTimeout(() => {
              conditionalField.style.maxHeight = '1000px';
              conditionalField.style.opacity = '1';
            }, 10);
          } else {
            // Hide with animation
            conditionalField.style.maxHeight = '0px';
            conditionalField.style.opacity = '0';
            
            setTimeout(() => {
              conditionalField.style.display = 'none';
            }, 300);
          }
          
          // Update required attribute on input fields inside
          const inputs = conditionalField.querySelectorAll('input, textarea, select');
          inputs.forEach(input => {
            if (shouldShow) {
              if (conditionalField.getAttribute('data-required') === 'true') {
                input.setAttribute('required', 'required');
              }
            } else {
              input.removeAttribute('required');
            }
          });
        };
        
        // Listen for changes
        conditionInput.addEventListener('change', toggleConditionalField);
        
        // For radio buttons, also listen to all radios in the group
        if (conditionInput.type === 'radio') {
          const radioGroup = this.element.querySelectorAll(`input[name="${conditionInput.name}"]`);
          radioGroup.forEach(radio => {
            radio.addEventListener('change', toggleConditionalField);
          });
        }
        
        // Initialize on page load
        toggleConditionalField();
      }
    });
  }

  /**
   * Disables the submit button after first click to prevent multiple submissions.
   * Triggered via data-action on the submit button.
   */
  disableOnSubmit(event) {
    const button = event.target;
    const form = button.closest("form");
    if (form && form.checkValidity()) {
      setTimeout(() => {
        button.disabled = true;
        if (button.tagName === "INPUT" && button.type === "submit") {
          button.value = "Submitting...";
        } else {
          button.innerText = "Submitting...";
        }
      }, 100);
    }
    // Do not call event.preventDefault() or event.stopPropagation()
  }
}
