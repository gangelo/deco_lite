# frozen_string_literal: true

module Deco
  # Provides class methods to return an appropriate model name.
  module ModelNameable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    # Class methods to extend.
    module ClassMethods
      def model_name
        ActiveModel::Name.new(self, nil, to_s.gsub('::', ''))
      end
    end
  end
end
