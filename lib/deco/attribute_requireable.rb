# frozen_string_literal: true

module Deco
  # Provides methods to manage attributes that must be defined from
  # the dynamically loaded data.
  module AttributeRequireable
    # Returns attribute names that will be used to validate the presence of
    # dynamically created attributes from loaded objects.
    #
    # You must override this method if you want to return attribute names that
    # are required to be present. You may simply return a static array, but
    # if you want to dynamically manipulate this attribute, return a variable.
    def required_attributes
      # @required_attributes ||= []
      []
    end
  end
end
