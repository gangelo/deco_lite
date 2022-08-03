module Deco
  # Provides class methods to return an appropriate model name.
  module ModelNameable
    def ModelNameable.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def model_name
        ActiveModel::Name.new(self, nil, to_s.gsub('::', ''))
      end
    end
  end
end
