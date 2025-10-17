module UsersHelper
  # Render a complete form section from UserFieldDefinitions
  def render_user_form_section(form, section_key, user = nil, wrapper_options = {})
    section_data = UserFieldDefinitions::USER_FIELDS[section_key]
    return "" unless section_data&.dig(:form_section)

    if wrapper_options[:no_wrapper]
      section_header(section_data) + 
      render_section_fields(form, section_data[:fields], user)
    else
      wrapper_class = wrapper_options[:class] || "card p-5 mb-5 card-shadow"
      wrapper_attrs = wrapper_options.except(:class, :no_wrapper)
      
      content_tag(:div, wrapper_attrs.merge(class: wrapper_class)) do
        section_header(section_data) + 
        render_section_fields(form, section_data[:fields], user)
      end
    end
  end

  # Helper method to check if a section should be displayed based on conditional logic
  def should_display_section?(user, section_data)
    return true unless section_data[:conditional_display]
    
    field_name = section_data[:conditional_display][:field]
    contains_value = section_data[:conditional_display][:contains]
    field_value = user.send(field_name)
    
    if field_value.is_a?(String) && field_value.present?
      begin
        parsed_value = JSON.parse(field_value)
        parsed_value.include?(contains_value) if parsed_value.is_a?(Array)
      rescue JSON::ParserError
        field_value.include?(contains_value)
      end
    else
      false
    end
  end

  # Helper method to check if a section has any content to display
  def section_has_content?(user, section_data)
    section_data[:fields].any? do |field_name, field_config|
      next if field_config[:virtual]
      field_has_value?(user, field_name, field_config)
    end
  end

  # Helper method to check if a field has a value worth displaying
  def field_has_value?(user, field_name, field_config)
    value = user.send(field_name)
    
    case field_config[:type]
    when :attachment, :attachments
      value.attached?
    when :checkbox_group
      value.present? && JSON.parse(value).any? rescue false
    else
      value.present?
    end
  end

  # Helper method to render user field values for display (show page)
  def render_user_field_value(user, field_name, field_config)
    value = user.send(field_name)
    
    case field_config[:type]
    when :date
      value&.strftime("%d/%m/%Y") || "Not provided"
    when :boolean
      value == true ? "Yes" : "No"
    when :attachment
      if value.attached?
        content_tag :span, class: "text-success" do
          "✓ Document Uploaded"
        end
      else
        "Not provided"
      end
    when :attachments
      if value.attached?
        content_tag :span, class: "text-success" do
          "✓ #{pluralize(value.count, 'Document')} Uploaded"
        end
      else
        "Not provided"
      end
    when :checkbox_group
      if value.present?
        services = JSON.parse(value) rescue []
        if services.any?
          content_tag :ul, class: "list-group mb-3" do
            services.map { |service| content_tag(:li, service, class: "list-group-item") }.join.html_safe
          end
        else
          "No services selected"
        end
      else
        "No services selected"
      end
    else
      value.presence || "Not provided"
    end
  end

  # Generate form fields dynamically based on UserFieldDefinitions
  def render_user_field(form, field_name, field_config, options = {})
    case field_config[:type]
    when :text
      render_text_field(form, field_name, field_config, options)
    when :textarea
      render_textarea_field(form, field_name, field_config, options)
    when :date
      render_date_field(form, field_name, field_config, options)
    when :boolean, :checkbox
      render_boolean_field(form, field_name, field_config, options)
    when :radio
      render_radio_field(form, field_name, field_config, options)
    when :select
      render_select_field(form, field_name, field_config, options)
    when :checkbox_group
      render_checkbox_group_field(form, field_name, field_config, options)
    when :attachment
      render_file_field(form, field_name, field_config, options)
    when :attachments
      render_file_field(form, field_name, field_config, options.merge(multiple: true))
    else
      render_text_field(form, field_name, field_config, options)
    end
  end

  def format_field_value(user, field_name, field_config)
    value = user.send(field_name)
    
    case field_config[:type]
    when :date
      value.present? ? value.strftime("%d/%m/%Y") : "-"
    when :boolean
      case field_config[:form_type]
      when :checkbox
        value == true ? "Yes" : "No"
      else
        value.present? ? (value ? "Yes" : "No") : "-"
      end
    when :attachment
      attachment = user.send(field_name)
      attachment.attached? ? "Yes" : "No"
    when :attachments
      attachments = user.send(field_name)
      if attachments.attached?
        count = attachments.count
        "Yes (#{count} file#{'s' if count != 1})"
      else
        "No"
      end
    else
      value.present? ? value.to_s : "-"
    end
  end

  # Text-specific helper for plain text emails
  def render_user_section_text(user, section_key)
    section = UserFieldDefinitions::USER_FIELDS[section_key]
    return "" unless section

    output = []
    output << "#{section[:title]}:"
    output << "-" * (section[:title].length + 1)
    
    section[:fields].each do |field_name, field_config|
      next if field_config[:virtual]
      label = field_config[:label]
      value = format_field_value(user, field_name, field_config)
      output << "#{label}: #{value}"
    end
    
    output << "" # Add blank line after section
    output.join("\n")
  end

  private

  def section_header(section_data)
    content = content_tag(:h4, section_data[:title], class: "mb-3")
    if section_data[:description]
      content += content_tag(:p, section_data[:description], class: "mb-3")
    end
    if section_data[:additional_info]
      content += content_tag(:ol, class: "ps-3 mb-4") do
        section_data[:additional_info].map do |info|
          content_tag(:li, raw(info))
        end.join.html_safe
      end
    end
    if section_data[:footer_info]
      content += content_tag(:p, raw(section_data[:footer_info]), class: "mb-3")
    end
    content
  end

  def render_section_fields(form, fields, user)
    render_fields_in_order(form, fields)
  end

  def render_fields_in_order(form, fields)
    output = []
    current_group = nil
    group_fields = []
    
    fields.each do |field_name, field_config|
      # Skip conditional fields that don't have their own form_group - they'll be rendered by their parent field
      next if field_config[:conditional] && !field_config[:form_group]
      
      field_group = field_config[:form_group]
      
      if field_group && field_group == current_group
        # Continue collecting fields for the current group
        group_fields << [field_name, field_config]
      else
        # Render any pending group before starting a new one
        if current_group && group_fields.any?
          output << render_field_group(form, group_fields.to_h)
          group_fields = []
        end
        
        if field_group
          # Start a new group
          current_group = field_group
          group_fields = [[field_name, field_config]]
        else
          # Render ungrouped field immediately
          current_group = nil
          output << render_field_with_conditionals(form, field_name, field_config, fields)
        end
      end
    end
    
    # Render any remaining group
    if current_group && group_fields.any?
      output << render_field_group(form, group_fields.to_h)
    end
    
    output.join.html_safe
  end

  def render_field_with_conditionals(form, field_name, field_config, all_fields)
    field_html = render_user_field(form, field_name, field_config)
    
    # Add conditional fields if this field has them
    if field_config[:conditional_fields]
      conditional_html = render_conditional_fields(form, field_name, field_config, all_fields)
      field_html += conditional_html
    end
    
    field_html.html_safe
  end

  def render_conditional_fields(form, parent_field, parent_config, all_fields)
    return "" unless parent_config[:conditional_fields]
    
    output = []
    
    parent_config[:conditional_fields].each do |condition_value, conditional_field_names|
      conditional_field_names.each do |conditional_field_name|
        conditional_field_config = all_fields[conditional_field_name]
        next unless conditional_field_config
        
        # Skip conditional fields that have their own form_group - they'll be rendered as a group
        next if conditional_field_config[:form_group]
        
        # Create wrapper div with data attributes for conditional display
        wrapper_attrs = {
          'data-user-form-target' => conditional_field_name.to_s.camelize(:lower),
          'data-condition-field' => parent_field,
          'data-condition-value' => condition_value,
          'style' => 'display: none;'
        }
        
        field_html = render_user_field(form, conditional_field_name, conditional_field_config)
        
        output << content_tag(:div, field_html, wrapper_attrs)
      end
    end
    
    output.join.html_safe
  end

  def render_field_group(form, fields)
    output = []
    
    # Check if any field in the group has a form_group_description
    group_description = fields.values.find { |config| config[:form_group_description] }&.dig(:form_group_description)
    
    # For conditional grouped fields, wrap the entire group (including description) with display: none
    all_conditional = fields.values.all? { |config| config[:conditional] }

    if all_conditional && group_description
      # Wrap description and fields together for conditional groups
      first_field_name = fields.keys.first
      wrapper_attrs = {
        'data-user-form-target' => first_field_name.to_s.camelize(:lower),
        'style' => 'display: none;'
      }
      
      group_content = []
      group_content << content_tag(:p, group_description, class: "mb-3")
      group_content << content_tag(:div, class: "row g-3") do
        fields.map do |field_name, field_config|
          content_tag :div, class: "col-md-6" do
            render_user_field(form, field_name, field_config)
          end
        end.join.html_safe
      end
      
      output << content_tag(:div, group_content.join.html_safe, wrapper_attrs)
    else
      # Regular group rendering
      if group_description
        output << content_tag(:p, group_description, class: "mb-3")
      end
      
      output << content_tag(:div, class: "row g-3") do
        fields.map do |field_name, field_config|
          content_tag :div, class: "col-md-6" do
            if field_config[:conditional]
              # Conditional grouped fields need wrapper with display: none
              wrapper_attrs = {
                'data-user-form-target' => field_name.to_s.camelize(:lower),
                'style' => 'display: none;'
              }
              content_tag(:div, render_user_field(form, field_name, field_config), wrapper_attrs)
            else
              render_user_field(form, field_name, field_config)
            end
          end
        end.join.html_safe
      end
    end
    
    output.join.html_safe
  end

  def render_text_field(form, field_name, field_config, options)
    css_classes = "form-control #{options[:class]}".strip
    required = field_config[:required] || options[:required] || false
    placeholder = field_config[:placeholder] || field_config[:label]
    
    stimulus_attrs = {}
    if field_config[:stimulus_target]
      stimulus_attrs['data-user-form-target'] = field_config[:stimulus_target]
    end
    
    content = ""
    
    # Add description if present
    if field_config[:description]
      content += content_tag(:p, raw(field_config[:description]), class: "mb-2 text-muted")
    end
    
    content += content_tag :div, class: "form-floating mb-3" do
      form.text_field(field_name, 
        class: css_classes, 
        placeholder: placeholder,
        required: required,
        **stimulus_attrs,
        **options.except(:class, :required)
      ) +
      form.label(field_name, field_config[:label])
    end
    
    content.html_safe
  end

  def render_textarea_field(form, field_name, field_config, options)
    css_classes = "form-control #{options[:class]}".strip
    placeholder = field_config[:placeholder] || field_config[:label]
    style = field_config[:style] || ""
    
    # Use custom ID if provided, otherwise let Rails generate it
    field_options = {
      class: css_classes, 
      placeholder: placeholder,
      style: style,
      **options.except(:class)
    }
    
    if field_config[:id]
      field_options[:id] = field_config[:id]
    end
    
    content = ""
    
    # Add description if present
    if field_config[:description]
      content += content_tag(:p, raw(field_config[:description]), class: "mb-2 text-muted")
    end
    
    # Add example if present
    if field_config[:example]
      content += content_tag(:div, class: "mb-3 p-3 bg-light rounded") do
        content_tag(:strong, "Example:", class: "d-block mb-1") +
        content_tag(:span, field_config[:example], class: "text-muted")
      end
    end
    
    content += content_tag(:div, class: "form-floating mb-3") do
      textarea_field = form.text_area(field_name, field_options)
      
      # Use custom ID for label if provided
      if field_config[:id]
        textarea_field + label_tag(field_config[:id], field_config[:label])
      else
        textarea_field + form.label(field_name, field_config[:label])
      end
    end
    
    content.html_safe
  end

  def render_checkbox_group_field(form, field_name, field_config, options)
    # Get current user's selected services
    current_values = []
    if form.object && form.object.send(field_name).present?
      stored_value = form.object.send(field_name)
      if stored_value.is_a?(String)
        begin
          current_values = JSON.parse(stored_value)
        rescue JSON::ParserError
          current_values = []
        end
      elsif stored_value.is_a?(Array)
        current_values = stored_value
      end
    end
    
    field_config[:sections].map do |section|
      content_tag(:div, class: "mb-4") do
        content_tag(:h5, section[:title], class: "mb-2") +
        content_tag(:p, section[:description], class: "mb-3") +
        section[:options].map do |option|
          content_tag(:div, class: "form-check ms-3") do
            stimulus_attrs = {}
            if option[:stimulus_target]
              stimulus_attrs['data-user-form-target'] = option[:stimulus_target]
            end
            
            # Check if this option is selected
            is_checked = current_values.include?(option[:value])
            checkbox_id = "service_#{option[:value].downcase.gsub(/[^a-z0-9]/, '_')}"
            
            form.check_box(field_name, 
              { 
                multiple: true, 
                class: "form-check-input service-checkbox", 
                id: checkbox_id, 
                checked: is_checked,
                **stimulus_attrs 
              }, 
              option[:value], nil
            ) +
            label_tag(checkbox_id, option[:label], class: "form-check-label")
          end
        end.join.html_safe
      end
    end.join.html_safe
  end

  def render_date_field(form, field_name, field_config, options)
    css_classes = "form-control #{options[:class]}".strip
    stimulus_attrs = {}
    if field_config[:stimulus_target]
      stimulus_attrs['data-user-form-target'] = field_config[:stimulus_target]
    end
    
    content_tag(:div, class: "form-floating mb-3", **stimulus_attrs) do
      form.date_field(field_name, 
        class: css_classes, 
        placeholder: "YYYY-MM-DD",
        **options.except(:class)
      ) +
      form.label(field_name, field_config[:label])
    end
  end

  def render_boolean_field(form, field_name, field_config, options)
    stimulus_attrs = {}
    if field_config[:stimulus_target]
      stimulus_attrs['data-user-form-target'] = field_config[:stimulus_target]
    end
    
    field_id = "user_#{field_name}"
    
    field_html = if field_config[:description]
      content_tag(:p, raw(field_config[:description]), class: "mt-3") +
      content_tag(:div, class: "form-check mb-3", **stimulus_attrs) do
        if field_config[:virtual]
          check_box_tag(field_name, "1", false, class: "form-check-input", id: field_id) +
          label_tag(field_id, field_config[:label], class: "form-check-label")
        else
          form.check_box(field_name, 
            class: "form-check-input",
            **options.except(:class)
          ) +
          form.label(field_name, field_config[:label], class: "form-check-label")
        end
      end
    else
      content_tag(:div, class: "form-check mb-3", **stimulus_attrs) do
        if field_config[:virtual]
          check_box_tag(field_name, "1", false, class: "form-check-input", id: field_id) +
          label_tag(field_id, field_config[:label], class: "form-check-label")
        else
          form.check_box(field_name, 
            class: "form-check-input",
            **options.except(:class)
          ) +
          form.label(field_name, field_config[:label], class: "form-check-label")
        end
      end
    end
    
    # Add separator if specified
    if field_config[:separator_after]
      field_html += content_tag(:hr, "", class: "my-4", style: "color: #b29c84;")
    end
    
    field_html
  end

  def render_radio_field(form, field_name, field_config, options)
    if field_config[:form_type] == :inline
      content_tag(:p, field_config[:label], class: "mt-3 mb-2") +
      content_tag(:fieldset, class: "mb-4") do
        content_tag(:legend, "#{field_config[:label].gsub('?', '')}", class: "visually-hidden") +
        field_config[:options].map do |option|
          content_tag(:div, class: "form-check form-check-inline me-4") do
            stimulus_attrs = {}
            if option[:stimulus_target]
              stimulus_attrs['data-user-form-target'] = option[:stimulus_target]
            end
            
            radio_id = "user_#{field_name}_#{option[:value].to_s.parameterize(separator: '_')}"
            
            form.radio_button(field_name, option[:value], 
              id: radio_id,
              class: "form-check-input",
              **stimulus_attrs,
              **options.except(:class)
            ) +
            label_tag(radio_id, option[:label], class: "form-check-label ms-1")
          end
        end.join.html_safe
      end
    else
      content_tag(:fieldset, class: "mb-3") do
        content_tag(:legend, field_config[:label], class: "col-form-label") +
        field_config[:options].map do |option|
          content_tag(:div, class: "form-check mb-2") do
            stimulus_attrs = {}
            if option[:stimulus_target]
              stimulus_attrs['data-user-form-target'] = option[:stimulus_target]
            end
            
            radio_id = "user_#{field_name}_#{option[:value].to_s.parameterize(separator: '_')}"
            
            form.radio_button(field_name, option[:value], 
              id: radio_id,
              class: "form-check-input",
              **stimulus_attrs,
              **options.except(:class)
            ) +
            label_tag(radio_id, option[:label], class: "form-check-label")
          end
        end.join.html_safe
      end
    end
  end

  def render_select_field(form, field_name, field_config, options)
    css_classes = "form-control form-select #{options[:class]}".strip
    
    # Get current value or use default if field is empty
    current_value = form.object.send(field_name)
    if current_value.blank? && field_config[:default]
      current_value = field_config[:default]
    end
    
    content = content_tag(:div, class: "form-floating mb-3") do
      form.select(field_name,
        options_for_select(field_config[:options].map { |opt| [opt, opt] }, current_value),
        { include_blank: "Select" },
        class: css_classes,
        **options.except(:class)
      ) +
      form.label(field_name, field_config[:label])
    end
    
    # Add note if present
    if field_config[:note]
      content += content_tag(:p, field_config[:note], class: "mb-3 text-muted small")
    end
    
    content
  end

  def render_file_field(form, field_name, field_config, options)
    multiple = options[:multiple] || false
    
    stimulus_attrs = {}
    if field_config[:stimulus_target]
      stimulus_attrs['data-user-form-target'] = field_config[:stimulus_target]
    end
    
    # Add overall container with label and description
    content_tag(:div, class: "rounded mb-3", **stimulus_attrs) do
      content = ""
      
      # Add label
      content += content_tag(:p, field_config[:label], class: "mb-1")
      
      # Add description if present
      if field_config[:description]
        content += content_tag(:p, raw(field_config[:description]), class: "mb-2 text-muted small")
      end
      
      # Add file upload container
      content += content_tag(:div, class: "file-upload-container") do
        content_tag(:label, for: "user_#{field_name}", class: "file-upload-label") do
          content_tag(:div, class: "upload-icon") do
            # SVG upload icon
            raw('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" fill="grey" style="width: 1em; height: 1em;"><path d="M246.6 9.4c-12.5-12.5-32.8-12.5-45.3 0l-128 128c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 109.3 192 320c0 17.7 14.3 32 32 32s32-14.3 32-32l0-210.7 73.4 73.4c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3l-128-128zM64 352c0-17.7-14.3-32-32-32s-32 14.3-32 32l0 64c0 53 43 96 96 96l256 0c53 0 96-43 96-96l0-64c0-17.7-14.3-32-32-32s-32 14.3-32 32l0 64c0 17.7-14.3 32-32 32L96 448c-17.7 0-32-14.3-32-32l0-64z" /></svg>')
          end +
          content_tag(:span, "Upload a file or drag & drop", class: "upload-text") +
          content_tag(:span, field_config[:file_types] || "PDF, JPG, PNG", class: "file-types") +
          form.file_field(field_name, 
            class: "file-upload-input",
            multiple: multiple,
            "data-user-form-target": "fileUploadInput",
            **options.except(:multiple, :class)
          )
        end
      end
      
      raw(content)
    end
  end
end
