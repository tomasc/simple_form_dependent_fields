module SimpleFormDependentFields
  class DependentFieldsBuilder
    extend Forwardable

    attr_accessor :builder, :template, :options

    BASE_DOM_CLASS = 'simple_form_dependent_fields'

    def initialize(builder, template, options = {})
      @builder = builder
      @template = template
      @options = options
    end

    def_delegators :builder, :object

    def dependent_fields(&block)
      html = template.capture(&block)

      tag_html = condition_valid? ? html : nil
      data_template_html = condition_valid? ? {} : { template_html: CGI.escapeHTML(html).html_safe }

      template.content_tag :div, tag_html, class: [dom_class, BASE_DOM_CLASS].reject(&:blank?).flatten, data: dom_data.merge(data_template_html)
    end

    private

    def dom_class
      options.fetch(:class, nil)
    end

    def dom_data
      { depends_on: options.slice(:depends_on_any, :depends_on_all, :depends_on_none) }
    end

    def depends_on_any
      options.fetch(:depends_on_any, nil)
    end

    def depends_on_all
      options.fetch(:depends_on_all, nil)
    end

    def depends_on_none
      options.fetch(:depends_on_none, nil)
    end

    def condition_valid?
      case
      when depends_on_any.present? then any_valid?
      when depends_on_all.present? then all_valid?
      when depends_on_none.present? then none_valid?
      end
    end

    def any_valid?
      return unless depends_on_any.present?
      depends_on_any.any? do |name, values|
        Array(values).any? do |value|
          is_valid?(name, value)
        end
      end
    end

    def all_valid?
      return unless depends_on_all.present?
      depends_on_all.all? do |name, values|
        Array(values).all? do |value|
          is_valid?(name, value)
        end
      end
    end

    def none_valid?
      return unless depends_on_none.present?
      depends_on_none.all? do |name, values|
        Array(values).none? do |value|
          is_valid?(name, value)
        end
      end
    end

    def is_valid?(name, value)
      return false unless object.respond_to?(name)
      value = nil if value == 'null'
      object.send(name) == value
    end
  end
end
