module SimpleFormDependentFields
  module ActionViewExtension
    module Builder
      def dependent_fields(options = {}, &block)
        SimpleFormDependentFields::DependentFieldsBuilder.new(self, @template, options).dependent_fields(&block)
      end
    end
  end
end

module ActionView::Helpers
  class FormBuilder
    include SimpleFormDependentFields::ActionViewExtension::Builder
  end
end
