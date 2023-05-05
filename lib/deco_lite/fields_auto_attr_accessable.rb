# frozen_string_literal: true

module DecoLite
  # Defines fields that may have attr_accessors automatically created for them
  # on the model.
  module FieldsAutoloadable
    private

    def auto_attr_accessors?
      auto_attr_accessors.present?
    end

    # This method returns a Hash of fields that are implicitly defined
    # through ActiveModel validators.
    def auto_attr_accessors
      return @auto_attr_accessors.dup if defined?(@auto_attr_accessors)

      @auto_attr_accessors = self.class.validators.filter_map do |validator|
        if validator.respond_to?(:attributes)
          validator.attributes
        elsif validator.respond_to?(:options)
          # This path handles the case where the validator is a custom validator
          # (i.e. `validates_with MyCustomValidator`). deco_lite in this case, has
          # no way of knowing what fields are being validated, so we have to rely
          # on the user to tell us what fields are being validated by passing
          # the attributes to validate in the #options hash. For example:
          # `validates_with MyCustomValidator, attributes: %i[field1 field2]`)
          # `validates_with MyCustomValidator, fields: %i[field1 field2]`)
          validator.options[:attributes].presence || validator.options[:fields].presence
        end
      end
      @auto_attr_accessors = auto_attr_accessors_assign
    end

    def auto_attr_accessors_assign
      @auto_attr_accessors.flatten.uniq.each_with_object({}) do |field_name, auto_attr_accessors_hash|
        auto_attr_accessors_hash[field_name] = nil
      end
    end
  end
end
