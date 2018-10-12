#= require lodash/4.17.10/index.js

do ($ = jQuery, window, document) ->
  pluginName = 'simple_form_dependent_fields'
  defaults =
    debug: false
    scope_selector: '.simple_form_dependent_fields__scope, .simple_form_dependent_fields__item, form'

  class Plugin
    constructor: (@element, options) ->
      @$element = $(@element)
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @scope_element = @get_scope_element()

      @form_update_handler = (e) =>
        return unless @$element.is(':visible')
        return unless @is_dependent_on_input($(e.target))
        return unless $(e.target).closest(@settings.scope_selector).is(@scope_element)
        @update_dependent_fields()
      @scope_element.on "change.#{pluginName}", 'input,select', @form_update_handler

      @update_dependent_fields()

    teardown: ->
      # we need to be specific to remove only handler of this updated fields
      # otherwise we might accidentally remove all handlers of all dependent fields
      # in the same form
      @scope_element.off ".#{pluginName}", 'input,select', @form_update_handler

    # ---------------------------------------------------------------------

    depends_on: -> @$element.data('depends-on')
    depends_on_any: -> @depends_on()['depends_on_any']
    depends_on_all: -> @depends_on()['depends_on_all']
    depends_on_none: -> @depends_on()['depends_on_none']

    # ---------------------------------------------------------------------

    get_form: -> @$element.closest('form')
    get_input: (name) -> @get_inputs().filter("[name$='[#{name}]']")
    get_input_names: -> Object.keys(@depends_on_any() || {}).concat Object.keys(@depends_on_all() || {}).concat Object.keys(@depends_on_none() || {})
    get_inputs: -> @scope_element.find('input,select').not(':hidden').filter (i, el) => $(el).closest(@settings.scope_selector).is(@scope_element)
    get_scope_element: -> @$element.closest(@settings.scope_selector)

    # ---------------------------------------------------------------------

    is_dependent_on_input: ($input) ->
      _.filter(@get_input_names(), (name) -> $input.is("[name$='[#{name}]']")).length > 0

    # ---------------------------------------------------------------------

    update_dependent_fields: -> if @is_condition_valid() then @show_content() else @hide_content()

    show_content: ->
      return if @$element.children().length > 0
      return unless html = @$element.data('template-html')
      @$element.append($(html))

    hide_content: ->
      template_html = @$element.children().remove()
      @$element.data('template-html', template_html) unless @$element.data('template-html')

    # ---------------------------------------------------------------------

    is_condition_valid: ->
      switch
        when @depends_on_any() then @is_any_valid()
        when @depends_on_all() then @is_all_valid()
        when @depends_on_none() then @is_none_valid()

    is_any_valid: ->
      res = false
      for name, values of @depends_on_any()
        for value in _.flatten([values])
          input_value = @is_valid(name, value)
          res = (res || input_value)
      res

    is_all_valid: ->
      res = true
      for name, values of @depends_on_all()
        for value in _.flatten([values])
          input_value = @is_valid(name, value)
          res = (res && input_value)
      res

    is_none_valid: ->
      res = true
      for name, values of @depends_on_none()
        for value in _.flatten([values])
          input_value = @is_valid(name, value)
          res = (res && !input_value)
      res

    is_valid: (name, value) ->
      $input = @get_input(name)
      value = value.toString()

      switch value
        when 'true' then value = '1'
        when 'false' then value = '0'

      switch $input.prop('type')
        when 'radio' then $input.filter(':checked').val() == value
        when 'checkbox'
          switch value
            when '1' then $input.filter(':checked').length > 0
            else $input.not(':checked').length > 0
        when 'select-one' then $input.val() == value
        when 'select-multiple' then value in $input.val()
        else $input.val() == value

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
