require 'simple_form'
require 'lodash-rails'

require 'simple_form_dependent_fields/version'

require 'simple_form_dependent_fields/action_view_extension'
require 'simple_form_dependent_fields/dependent_fields_builder'

module SimpleFormDependentFields
  def self.asset_path
    File.expand_path("../assets/javascripts", __FILE__)
  end
end
