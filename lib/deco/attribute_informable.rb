# frozen_string_literal: true

module Deco
  # Creates and returns a hash given the parameters that are used to
  # dynamically create attributes and assign values to a model.
  module AttributeInformable
    # This method simply navigates the payload hash received and creates qualified
    # hash key names that can be used to verify/map to our attribute names in this model.
    # This can be used to qualify nested hash attributes and saves us some headaches
    # if there are nested attribute names with the same name:
    #
    # given:
    #
    # hash = {
    #   first_name: 'first_name',
    #   ...
    #   address: {
    #     street: '',
    #     ...
    #   }
    # }
    #
    # attribute_info_from(hash: hash) #=>
    #
    # {
    #   :first_name=>{:attribute_name=>:first_name, :namespace=>[]},
    #   ...
    #   :address_street=>{:attribute_name=>:street, :namespace=>[:address]},
    #   ...
    # }
    #
    # The generated, qualified attribute names expected to map to our model, because we named
    # them as such.
    #
    # :attribute_name is the actual, unqualified attribute name found in the payload hash sent.
    # :namespace is the hash key by which :attribute_name can be found in the payload hash if need be.
    def attribute_info_from(hash:, field_namespace:, namespace: [], attribute_name_info: {})
      hash.each do |key, value|
        if value.is_a? Hash
          namespace << key
          attribute_info_from hash: value, field_namespace: field_namespace,
                              namespace: namespace, attribute_name_info: attribute_name_info
          namespace.pop
          next
        end

        namespace = namespace.dup
        field_key = attribute_info_field_key_from(key: key,
                                                  field_namespace: field_namespace,
                                                  namespace: namespace)
        attribute_name_info[field_key] = { attribute_name: key, namespace: namespace }
      end

      attribute_name_info
    end

    def attribute_info_field_key_from(key:, field_namespace:, namespace:)
      return key if field_namespace.blank? && namespace.blank?
      return "#{field_namespace}_#{key}".to_sym if namespace.blank?
      return "#{namespace.join('_')}_#{key}".to_sym if field_namespace.blank?

      "#{field_namespace}_#{namespace.join('_')}_#{key}".to_sym
    end
  end
end
