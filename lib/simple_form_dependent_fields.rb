require 'simple_form'

require 'simple_form_dependent_fields/version'

require 'simple_form_dependent_fields/action_view_extension'
require 'simple_form_dependent_fields/dependent_fields_builder'
require 'simple_form_dependent_fields/railtie' if defined?(Rails)

module SimpleFormDependentFields
  def self.asset_path
    File.expand_path("../assets/javascripts", __FILE__)
  end
end
