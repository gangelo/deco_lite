# frozen_string_literal: true

module DecoLite
  # Defines methods to transform a field name into a field name
  # with a namespace.
  module FieldNameNamespaceable
    def field_name_or_field_name_with_namespace(field_name:, options:)
      return field_name unless options.namespace?

      field_name_with_namespace(field_name: field_name, namespace: options.namespace)
    end

    def field_name_with_namespace(field_name:, namespace:)
      "#{namespace}_#{field_name}"
    end
  end
end
