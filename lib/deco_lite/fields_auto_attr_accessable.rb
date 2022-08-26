# frozen_string_literal: true

module DecoLite
  # Defines fields that may have attr_accessors automatically created for them
  # on the model.
  module FieldsAutoloadable
    private

    def auto_attr_accessors?
      auto_attr_accessors.present?
    end

    # This method returns a Hash of fields that are implicitly defined either
    # through ActiveModel validators or by returning them from the
    # #required_fields Array.
    def auto_attr_accessors
      return @auto_attr_accessors.dup if defined?(@auto_attr_accessors)

      @auto_attr_accessors = self.class.validators.map(&:attributes)
      @auto_attr_accessors.concat(required_fields) if options.required_fields_auto?
      @auto_attr_accessors = auto_attr_accessors_assign
    end

    def auto_attr_accessors_assign
      @auto_attr_accessors.flatten.uniq.each_with_object({}) do |field_name, auto_attr_accessors_hash|
        auto_attr_accessors_hash[field_name] = nil
      end
    end
  end
end
