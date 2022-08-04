# frozen_string_literal: true

module Deco
  # Provides methods to manage fields that must be defined from
  # the dynamically loaded data.
  module FieldRequireable
    # Returns field names that will be used to validate the presence of
    # dynamically created fields from loaded objects.
    #
    # You must override this method if you want to return field names that
    # are required to be present. You may simply return a static array, but
    # if you want to dynamically manipulate this field, return a variable.
    def required_fields
      # @required_fields ||= []
      []
    end
  end
end
