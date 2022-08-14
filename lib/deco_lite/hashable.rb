module DecoLite
  # Provides methods to convert the object to a Hash.
  module Hashable
    def to_h
      field_names.each.inject({}) do |hash, field_name|
        hash[field_name] = public_send field_name
        hash
      end
    end
  end
end
