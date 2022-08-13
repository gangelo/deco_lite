# frozen_string_literal: true

module DecoLite
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
    # get_field_info(hash: hash) #=>
    #
    # {
    #   :first_name=>{:field_name=>:first_name, :dig=>[]},
    #   ...
    #   :address_street=>{:field_name=>:street, :dig=>[:address]},
    #   ...
    # }
    #
    # The generated, qualified field names expected to map to our model, because we named
    # them as such.
    #
    # :field_name is the actual, unqualified field name found in the payload hash sent.
    # :dig is the hash key by which :field_name can be found in the payload hash if need be -
    #   retained across recursive calls.
    def get_field_info(hash:, namespace: nil, dig: [], field_info: {})
      hash.each do |key, value|
        if value.is_a? Hash
          get_field_info hash: value,
                         namespace: namespace,
                         dig: dig << key,
                         field_info: field_info
          dig.pop
        else
          set_field_info!(field_info: field_info,
                          key: key,
                          namespace: namespace,
                          dig: dig)
        end
      end

      field_info
    end

    def set_field_info!(field_info:, key:, namespace:, dig:)
      field_key = [namespace, *dig, key].compact.join('_').to_sym
      field_info[field_key] = {
        field_name: key,
        dig: dig.dup
      }
    end

    def merge_field_info!(field_info:)
      @field_info.merge!(field_info)
    end

    def field_names
      field_info&.keys || []
    end

    attr_reader :field_info

    private

    attr_writer :field_info

    module_function :get_field_info, :set_field_info!, :merge_field_info!
  end
end
