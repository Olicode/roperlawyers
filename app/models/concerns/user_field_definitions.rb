module UserFieldDefinitions
  extend ActiveSupport::Concern

  # Define all user fields with their display names, types, and formatting
  USER_FIELDS = {
    # Personal Details
    personal: {
      title: "Personal details",
      form_section: true,
      fields: {
        first_name: { label: "First name", type: :text, required: true, form_group: :name },
        last_name: { label: "Last name", type: :text, required: true, form_group: :name },
        email: { label: "Email address", type: :text, required: true },
        mobile_phone: { label: "Mobile phone number", type: :text, required: true },
        home_address: { label: "Home address", type: :text },
        profession: { label: "Profession", type: :text },
        marital_status: { label: "Marital status", type: :text, form_group: :marital },
        spouse: { label: "Spouse full name", type: :text, form_group: :marital },
        tax_resident: { 
          label: "Yes – I am a tax resident in Spain",
          email_label: "Tax resident",
          type: :boolean, 
          form_type: :checkbox,
          description: "Are you a tax resident in Spain?<br><small class='text-muted'>You're tax resident if you spend over 183 days a year in Spain or your main ties are here.<br>If you live mostly abroad, you're non-resident even if you own or rent out property in Spain.</small>",
          stimulus_target: "taxResident",
          conditional_fields: {
            true => [:tax_representative_form]
          }
        },
        tax_representative_form: {
          label: "Who is your tax representative?",
          type: :text,
          required: true,
          conditional: true,
          stimulus_target: "taxRepresentativeForm",
          separator_after: true
        }
      }
    },

    # Passport Details
    passport: {
      title: "Passport details",
      form_section: true,
      fields: {
        full_name_on_passport: { label: "Full name on passport", type: :text },
        passport_number: { label: "Passport number", type: :text },
        date_of_birth: { label: "Date of birth", type: :date, form_group: :passport_dates },
        place_of_birth: { 
          label: "Place of birth", 
          type: :text, 
          form_group: :passport_dates,
          email_label: "Place of Birth"
        },
        expiry_date: { label: "Passport expiry date", type: :date, form_group: :passport_dates },
        nationality: { 
          label: "Nationality", 
          type: :select,
          options: %w[Belgian British Chinese Danish Dutch Finnish French German Greek Indian Irish Italian Norwegian Polish Spanish Swedish Swiss Romanian]
        },
        passport_document: { 
          label: "Upload a copy of your passport",
          email_label: "Passport",
          type: :attachment,
          file_types: "PDF, JPG, PNG"
        }
      }
    },

    # Requested Services
    requested_services: {
      title: "Requested Services",
      form_section: true,
      description: "Please tick all the services you would like us to assist you with:",
      fields: {
        requested_services: {
          label: "Services",
          type: :checkbox_group,
          sections: [
            {
              title: "Property Transactions",
              description: "If you're buying or selling a property, please select the relevant option:",
              options: [
                { value: "Purchase", label: "I am purchasing a property", stimulus_target: "servicePurchase" },
                { value: "Sale", label: "I am selling a property", stimulus_target: "serviceSale" }
              ]
            },
            {
              title: "Legal Documents",
              description: "If you would like us to prepare any of the following legal documents, please tick below:",
              options: [
                { value: "Will & Last Testament", label: "Will & Last Testament", stimulus_target: "serviceWill" },
                { value: "New Build Declaration", label: "New Build Declaration", stimulus_target: "serviceNewBuild" },
                { value: "Donation", label: "Donation", stimulus_target: "serviceDonation" }
              ]
            },
            {
              title: "Holiday Let Compliance (Short-Term Rentals)",
              description: "If you plan to holiday let your property, three legal steps are required. Tick any you'd like us to handle:",
              options: [
                { value: "VV Licence", label: "Apply for VV Licence", stimulus_target: "serviceVv" },
                { value: "Unified Registry", label: "Register with the Unified Registry", stimulus_target: "serviceRegistry" },
                { value: "Classified Activities", label: "Submit Classified Activities Declaration", stimulus_target: "serviceActivities" }
              ]
            }
          ]
        }
      }
    },

    # Property Sale Details
    property_sale: {
      title: "Property Sale Details",
      form_section: true,
      conditional_display: { field: "requested_services", contains: "Sale" },
      stimulus_target: "sectionSale",
      fields: {
        selling_property_address: {
          label: "Selling Property Address",
          type: :textarea,
          style: "height: 120px;",
          id: "property_sale_selling_property_address"
        }
      }
    },

    # New Build Declaration
    new_build_declaration: {
      title: "New Build Declaration Information",
      form_section: true,
      conditional_display: { field: "requested_services", contains: "New Build Declaration" },
      stimulus_target: "sectionNewBuild",
      fields: {
        selling_property_address: {
          label: "Selling Property Address",
          type: :textarea,
          style: "height: 120px;",
          id: "new_build_declaration_selling_property_address"
        }
      }
    },

    # Property Purchase Details
    property_purchase: {
      title: "Property Purchase Details",
      form_section: true,
      description: "Enter the address of the property you intend to purchase:",
      conditional_display: { field: "requested_services", contains: "Purchase" },
      stimulus_target: "sectionPurchase",
      fields: {
        buying_property_address: {
          label: "Property Address",
          type: :textarea,
          style: "height: 120px;",
          id: "property_purchase_buying_property_address"
        },
        currency: {
          label: "What currency are your funds in?",
          type: :radio,
          form_type: :inline,
          options: [
            { value: "EUR", label: "EUR (€)" },
            { value: "GBP", label: "GBP (£)" }
          ]
        },
        fx_quote_referral_consent: {
          label: "Would you like us to pass your contact details to a trusted currency exchange company for a quote? (e.g., pounds to euros or vice versa)",
          email_label: "FX Quote Referral Consent",
          type: :radio,
          form_type: :inline,
          options: [
            { value: true, label: "Yes" },
            { value: false, label: "No" }
          ]
        },
        needs_mortgage: {
          label: "Will you need a mortgage?",
          email_label: "Needs Mortgage",
          type: :radio,
          form_type: :inline,
          stimulus_target: "needsMortgage",
          options: [
            { value: "Yes", label: "Yes", stimulus_target: "needsMortgageYes" },
            { value: "No", label: "No", stimulus_target: "needsMortgageNo" }
          ]
        },
        wants_to_holiday_let: {
          label: "Do you plan to rent the property as a holiday let?",
          email_label: "Wants to Holiday Let",
          type: :radio,
          form_type: :inline,
          stimulus_target: "wantsToHolidayLet",
          options: [
            { value: "Yes", label: "Yes", stimulus_target: "wantsToHolidayLetYes" },
            { value: "No", label: "No", stimulus_target: "wantsToHolidayLetNo" }
          ]
        }
      }
    },

    # Bank Details
    bank_details: {
      title: "Bank details",
      form_section: true,
      description: "Property purchase payments are typically made in three stages:",
      additional_info: [
        "<strong>Reservation fee</strong> (1%) – to take the property off the market (estate‑agency sales only).",
        "<strong>Deposit on exchange</strong> 9% (10% if no reservation fee) – due on exchange of contracts.",
        "<strong>Balance on completion</strong> – the remaining amount on completion day."
      ],
      footer_info: "Under Spanish anti‑money‑laundering rules, the notary requires the bank name and IBAN of the account used for each payment (e.g. HSBC, IBAN GB29 MIDL 4012 3456 7890 12).<br>Please fill in the details below for each payment stage.",
      fields: {
        will_pay_reservation: {
          label: "Have you paid—or will you pay—a reservation fee (under an estate‑agent agreement, if applicable)?",
          type: :radio,
          form_type: :inline,
          stimulus_target: "pay",
          virtual: true,
          options: [
            { value: "yes", label: "Yes", stimulus_target: "payYes" },
            { value: "no", label: "No", stimulus_target: "payNo" }
          ],
          conditional_fields: {
            "yes" => [:r_origin_bank_details]
          }
        },
        r_origin_bank_details: {
          label: "Reservation fee account",
          type: :text,
          placeholder: "Enter reservation fee bank name and IBAN",
          conditional: true,
          stimulus_target: "reservationDepositAccount"
        },
        use_same_account: {
          label: "Use the same account for all payments",
          type: :checkbox,
          stimulus_target: "sameBox",
          virtual: true
        },
        otb_origin_bank_details: {
          label: "Deposit on exchange account",
          type: :text,
          placeholder: "Enter deposit on exchange bank name and IBAN",
          stimulus_target: "privateContractAccount"
        },
        balance_bank_details: {
          label: "Balance on completion account",
          type: :text,
          placeholder: "Enter balance on completion bank name and IBAN",
          stimulus_target: "remainingBalanceAccount"
        },
        has_spanish_account: {
          label: "Do you have a Spanish bank account for utilities standing orders?",
          type: :radio,
          form_type: :inline,
          stimulus_target: "hasSpanishAccount",
          virtual: true,
          options: [
            { value: "yes", label: "Yes", stimulus_target: "hasSpanishAccountYes" },
            { value: "no", label: "No", stimulus_target: "hasSpanishAccountNo" }
          ],
          conditional_fields: {
            "yes" => [:standing_orders_bank_details]
          }
        },
        standing_orders_bank_details: {
          label: "Utility standing order account",
          type: :text,
          placeholder: "Enter utility standing order bank name and IBAN",
          conditional: true,
          stimulus_target: "utilityAccount"
        }
      }
    },

    # Power of Attorney
    power_of_attorney: {
      title: "Power of Attorney (PoA)",
      form_section: true,
      description: "By granting us a Power of Attorney, we'll handle everything for you.",
      conditional_display: { field: "requested_services", contains: "Purchase" },
      stimulus_target: "poaSection",
      fields: {
        needs_poa: {
          label: "Would you like to grant us PoA?",
          email_label: "Needs PoA",
          type: :radio,
          stimulus_target: "needsPoa",
          options: [
            { value: "yes", label: "Yes – please act on my behalf", stimulus_target: "needsPoaYes" },
            { value: "no", label: "No – I do not require PoA", stimulus_target: "needsPoaNo" },
            { value: "already", label: "Another person holds PoA and will act on my behalf – please let us know and send us a copy", stimulus_target: "needsPoaAlready" }
          ],
          conditional_fields: {
            "yes" => [:poa_for, :poa_made_in_spain]
          }
        },
        poa_for: {
          label: "Which matters should your PoA cover?",
          email_label: "POA For",
          type: :radio,
          conditional: true,
          options: [
            { value: "buying", label: "Buying – purchase property on my behalf" },
            { value: "selling", label: "Selling – sell property on my behalf" },
            { value: "both", label: "Buying & Selling – handle both purchase and sale" },
            { value: "all", label: "Buying, Selling & Mortgage – full conveyancing and mortgage powers" }
          ]
        },
        poa_made_in_spain: {
          label: "Where would you like to sign your PoA?",
          email_label: "POA Made in Spain",
          type: :radio,
          conditional: true,
          options: [
            { value: "yes", label: "In Spain – sign before a Spanish notary with one of our team accompanying you" },
            { value: "no", label: "At your local notary – we'll send a draft for you to sign and have it returned by courier" }
          ]
        }
      }
    },

    # NIE Information
    nie_information: {
      title: "NIE number",
      form_section: true,
      description: "An NIE (Foreigner Identification Number) is required for most official processes in Spain, including legal, financial, and administrative transactions.",
      fields: {
        needs_nie: { 
          label: "Would you like us to apply for your NIE?", 
          email_label: "Needs NIE",
          type: :radio,
          options: [
            { value: "no", label: "No – I already have an NIE", stimulus_target: "nieNoRadio" },
            { value: "yes", label: "Yes – please apply on my behalf", stimulus_target: "nieYesRadio" }
          ],
          conditional_fields: {
            "no" => [:nie_number, :nie_document],
            "yes" => [:father_s_first_name, :mother_s_first_name]
          }
        },
        nie_number: { label: "NIE number", type: :text, conditional: true },
        nie_document: { 
          label: "Upload a copy of your NIE document", 
          email_label: "NIE Document",
          type: :attachment,
          file_types: "PDF, JPG, PNG",
          conditional: true
        },
        father_s_first_name: { 
          label: "Father's first name", 
          type: :text, 
          conditional: true, 
          form_group: :parents,
          form_group_description: "Please enter your parents' first names so we can apply for your NIE:"
        },
        mother_s_first_name: { 
          label: "Mother's first name", 
          type: :text, 
          conditional: true, 
          form_group: :parents
        }
      }
    },

    # Will & Testament
    will_testament: {
      title: "Last Will and Testament",
      form_section: true,
      description: "Should you require a Will and Last Testament, kindly provide the necessary information below.",
      conditional_display: { field: "requested_services", contains: "Will & Last Testament" },
      stimulus_target: "sectionWill",
      fields: {
        currently_married: {
          label: "Are you currently married?",
          type: :radio,
          form_type: :inline,
          stimulus_target: "currentlyMarried",
          virtual: true,
          options: [
            { value: true, label: "Yes", stimulus_target: "currentlyMarriedTrue" },
            { value: false, label: "No", stimulus_target: "currentlyMarriedFalse" }
          ],
          conditional_fields: {
            true => [:name_of_the_present_spouse]
          }
        },
        name_of_the_present_spouse: {
          label: "Full name of present spouse",
          type: :text,
          placeholder: "Name of present spouse",
          conditional: true
        },
        previously_married: {
          label: "Have you been married before?",
          type: :radio,
          form_type: :inline,
          stimulus_target: "previouslyMarried",
          virtual: true,
          options: [
            { value: true, label: "Yes", stimulus_target: "previouslyMarriedTrue" },
            { value: false, label: "No", stimulus_target: "previouslyMarriedFalse" }
          ],
          conditional_fields: {
            true => [:name_of_the_previous_spouses, :date_of_divorce, :date_of_decease]
          }
        },
        name_of_the_previous_spouses: {
          label: "Full name of previous spouse(s)",
          type: :text,
          placeholder: "Full name of previous spouse(s)",
          conditional: true
        },
        date_of_divorce: {
          label: "Date of divorce",
          type: :date,
          placeholder: "Date of divorce (DD/MM/YYYY)",
          description: "If divorced, enter date of decree absolute:",
          conditional: true
        },
        date_of_decease: {
          label: "Date of death",
          type: :date,
          placeholder: "Date of death (DD/MM/YYYY)",
          description: "If widowed, enter date of spouse's death:",
          conditional: true
        },
        father_s_full_name: {
          label: "Full name of your father",
          type: :text,
          placeholder: "Full name of your father",
        },
        father_s_vital_status: {
          label: "Is your father alive?",
          email_label: "Father's Vital Status",
          type: :radio,
          form_type: :inline,
          options: [
            { value: "Yes", label: "Yes" },
            { value: "No", label: "No" }
          ]
        },
        mother_s_full_name: {
          label: "Full name of your mother",
          type: :text,
          placeholder: "Full name of your mother",
        },
        mother_s_vital_status: {
          label: "Is your mother alive?",
          email_label: "Mother's Vital Status",
          type: :radio,
          form_type: :inline,
          options: [
            { value: "Yes", label: "Yes" },
            { value: "No", label: "No" }
          ]
        },
        children: {
          label: "Children & dependents",
          type: :text,
          placeholder: "Children (Name | DOB DD/MM/YYYY)",
          description: "Please enter your children & dependants full name, date of birth, and place of birth."
        },
        outline_of_bequests_and_oder_of_success: {
          label: "Beneficiaries & gifts",
          type: :textarea,
          placeholder: "Outline of Bequests & Order of Succession",
          description: "List the individuals or organisations you wish to inherit your estate, along with the item and percentage each should receive. You may also name an alternative beneficiary in case someone is unable to inherit.",
          example: "All assets in Spain: John Smith – 50%, Anna Smith – 50%. If John is unable to inherit, his share should pass to James Clarke."
        },
        inheritance_to_be_governed_by: {
          label: "Inheritance governed by",
          type: :select,
          description: "Select the country whose laws you would like to govern your inheritance:",
          options: [
            "Law of country of current nationality",
            "Nationality at the time of death",
            "Habitual place of residence at the time of death"
          ],
          default: "Law of country of current nationality",
          note: "Most people making a will choose the 'Law of country of current nationality'."
        }
      }
    },

    # VV License Documents
    vv_license_documents: {
      title: "Documents",
      form_section: true,
      description: "Documents required to be uploaded:",
      conditional_display: { field: "requested_services", contains: "VV Licence" },
      stimulus_target: "sectionDocuments",
      fields: {
        can_provide_title_deed: {
          label: "Can you provide the Title Deed (Escritura)?",
          type: :radio,
          virtual: true,
          stimulus_target: "canProvideTitleDeed",
          options: [
            { value: "Yes, I will upload it now", label: "Yes, I will upload it now", stimulus_target: "canProvideTitleDeedUploadNow" },
            { value: "Yes, but I will send it later", label: "Yes, but I will send it later", stimulus_target: "canProvideTitleDeedSendLater" },
            { value: "I can't find it", label: "I can't find it", stimulus_target: "canProvideTitleDeedCantFind" }
          ],
          conditional_fields: {
            "Yes, I will upload it now" => [:title_deed_documents]
          }
        },
        title_deed_documents: {
          label: "Upload Title Deed (Escritura)",
          email_label: "Title Deed (Escritura)",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          conditional: true
        },
        nota_simple_documents: {
          label: "Upload Nota Simple (Land Registry Ownership Certificate)",
          email_label: "Nota Simple (Land Registry Ownership Certificate)",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          description: "If you don't have a recent copy of the Land Registry Ownership Certificate (Nota Simple), we can obtain it for you."
        },
        energy_efficiency_certificate_cee: {
          label: "Energy Efficiency Certificate (CEE) Status",
          type: :radio,
          stimulus_target: "energyEfficiencyCertificateCee",
          options: [
            { value: "Provided", label: "Yes, I will upload it now", stimulus_target: "energyEfficiencyCertificateCeeProvided" },
            { value: "Client Will Provide", label: "Yes, but I will send it later", stimulus_target: "energyEfficiencyCertificateCeeClientWillProvide" },
            { value: "We Need to Apply", label: "No, please obtain one on my behalf", stimulus_target: "energyEfficiencyCertificateCeeWeNeedToApply" }
          ],
          description: "If you do not have this document, our office can manage the application on your behalf through a certified technician.",
          conditional_fields: {
            "Provided" => [:cee_documents]
          }
        },
        cee_documents: {
          label: "Upload Energy Efficiency Certificate (CEE)",
          email_label: "Energy Efficiency Certificate (CEE)",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          conditional: true
        },
        vv_license_documents: {
          label: "Upload VV License",
          email_label: "VV License",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          stimulus_target: "vvLicenseUploadSection",
        },
        first_occupation_license_documents: {
          label: "Upload First Occupation License",
          email_label: "First Occupation License",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          description: "If you do not have this document, our office can manage the application on your behalf and liaise with the relevant authorities."
        },
        habitability_certificate_documents: {
          label: "Upload Habitability Certificate",
          email_label: "Habitability Certificate",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
        },
        municipal_certificate_documents: {
          label: "Upload Municipal Certificate",
          email_label: "Municipal Certificate",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
        },
        property_tax_receipt_documents: {
          label: "Upload Annual Property Tax Receipt (IBI)",
          email_label: "Property Tax Receipt",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
        },
        floor_plan_documents: {
          label: "Upload Floor Plan",
          email_label: "Floor Plan",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
        },
        community_approval_documents: {
          label: "Upload Community Approval",
          email_label: "Community Approval",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          description: "Certificate issued by the community of owners confirming that short-term rentals are permitted within the building or development."
        },
        civil_liability_insurance_policy_documents: {
          label: "Upload Civil Liability Insurance Policy",
          email_label: "Civil Liability Insurance Policy",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          stimulus_target: "civilLiabilitySection",
        },
        igic_registration_modelo_400_document: {
          label: "Upload IGIC Registration (Modelo 400) document",
          email_label: "IGIC Registration (Modelo 400)",
          type: :attachment,
          file_types: "PDF, JPG, PNG",
          stimulus_target: "igicRegistrationSection",
        },
        water_bill_documents: {
          label: "Upload Water Bill documents",
          email_label: "Water Bill",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          stimulus_target: "waterBillSection",
        },
        electricity_bill_documents: {
          label: "Upload Electricity Bill",
          email_label: "Electricity Bill",
          type: :attachments,
          file_types: "PDF, JPG, PNG",
          stimulus_target: "electricityBillSection",
        },
      }
    },
  }.freeze

  # Helper method to format field values for display
  def format_field_value(field_name, value, field_config)
    return "-" if value.blank?

    case field_config[:type]
    when :date
      value.strftime("%d/%m/%Y")
    when :boolean
      value == true ? "Yes" : "No"
    when :attachment
      value.attached? ? "✓ Document Uploaded" : "No"
    when :attachments
      value.attached? ? "✓ #{value.count} Document#{'s' if value.count != 1} Uploaded" : "No"
    when :checkbox_group
      # Handle requested_services which is stored as JSON string
      if value.is_a?(String)
        begin
          parsed_services = JSON.parse(value)
          parsed_services.is_a?(Array) ? parsed_services.join(", ") : value.to_s
        rescue JSON::ParserError
          value.to_s
        end
      elsif value.is_a?(Array)
        value.join(", ")
      else
        value.to_s
      end
    else
      value.to_s
    end
  end

  # Get all field names as a flat array (useful for monitoring changes)
  def self.all_field_names
    USER_FIELDS.values.flat_map { |section| section[:fields].keys }.map(&:to_s)
  end

  # Get all attachment fields across all sections
  def self.all_attachment_fields
    attachment_fields = []
    
    USER_FIELDS.each do |section_key, section_data|
      section_data[:fields].each do |field_name, field_config|
        if [:attachment, :attachments].include?(field_config[:type])
          attachment_fields << {
            field_name: field_name,
            field_config: field_config,
            section_key: section_key,
            section_title: section_data[:title]
          }
        end
      end
    end
    
    attachment_fields
  end

  # Get all non-attachment fields across all sections
  # Returns the same structure as USER_FIELDS but without attachment fields or sections that only contain attachments
  def self.all_non_attachment_fields
    filtered_fields = {}
    
    USER_FIELDS.each do |section_key, section_data|
      # Skip sections that only contain attachment fields (like vv_license_documents)
      non_attachment_fields_in_section = section_data[:fields].reject do |field_name, field_config|
        [:attachment, :attachments].include?(field_config[:type])
      end
      
      # Only include the section if it has non-attachment fields
      if non_attachment_fields_in_section.any?
        filtered_fields[section_key] = section_data.dup
        filtered_fields[section_key][:fields] = non_attachment_fields_in_section
      end
    end
    
    filtered_fields
  end
end
