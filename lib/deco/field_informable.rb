# frozen_string_literal: true

module Deco
  # Creates and returns a hash given the parameters that are used to
  # dynamically create fields and assign values to a model.
  module FieldInformable
    # This method simply navigates the payload hash received and creates qualified
    # hash key names that can be used to verify/map to our field names in this model.
    # This can be used to qualify nested hash fields and saves us some headaches
    # if there are nested field names with the same name:
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
    # field_info_from(hash: hash) #=>
    #
    # {
    #   :first_name=>{:field_name=>:first_name, :namespace=>[]},
    #   ...
    #   :address_street=>{:field_name=>:street, :namespace=>[:address]},
    #   ...
    # }
    #
    # The generated, qualified field names expected to map to our model, because we named
    # them as such.
    #
    # :field_name is the actual, unqualified field name found in the payload hash sent.
    # :namespace is the hash key by which :field_name can be found in the payload hash if need be -
    #   retained across recursive calls.
    def field_info_from(hash:, namespace: [], field_info: {})
      hash.each do |key, value|
        if value.is_a? Hash
          field_info_from hash: value,
                              namespace: namespace << key,
                              field_info: field_info
          namespace.pop
        else
          add_field_info_to(field_info: field_info,
                                key: key,
                                namespace: namespace)
        end
      end

      field_info
    end

    def add_field_info_to(field_info:, key:, namespace:)
      field_key = [*namespace, key].compact.join('_').to_sym
      field_info[field_key] = {
        field_name: key,
        namespace: namespace.dup
      }
    end

    attr_reader :field_info

    private

    attr_writer :field_info

    module_function :field_info_from, :add_field_info_to
  end
end
