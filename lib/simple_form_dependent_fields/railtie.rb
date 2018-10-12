require "rails"

module SimpleFormDependentFields
  class Railtie < Rails::Railtie
    initializer "simple_form_dependent_fields.assets" do |app|
      app.config.assets.paths << SimpleFormDependentFields.asset_path
    end
  end
end
