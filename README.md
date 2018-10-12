# Simple Form Dependent Fields

[![Build Status](https://travis-ci.org/tomasc/simple_form_dependent_fields.svg)](https://travis-ci.org/tomasc/simple_form_dependent_fields) [![Gem Version](https://badge.fury.io/rb/simple_form_dependent_fields.svg)](http://badge.fury.io/rb/simple_form_dependent_fields) [![Coverage Status](https://img.shields.io/coveralls/tomasc/simple_form_dependent_fields.svg)](https://coveralls.io/r/tomasc/simple_form_dependent_fields)

Dependent fields helper for [`simple_form`](https://github.com/plataformatec/simple_form).

Show or hide dependent fields in forms based on checkboxes, radios and selects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_form_dependent_fields'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_form_dependent_fields

## Usage

```ERB
<%= simple_form_for @my_doc do |f| %>
  <%= f.input :doc_type, as: :select, collection: %w[text image video], include_blank: false %>

  <%= f.dependent_fields depends_on_any: { doc_type: 'text' } do %>
    <%= f.input :text %>
    <%= f.input :has_title, as: :boolean %>
  <% end %>

  <%= f.dependent_fields depends_on_all: { doc_type: 'text', has_title: true } do %>
    <%= f.input :title %>
  <% end %>

  <%= f.dependent_fields depends_on_none: { doc_type: 'text' } do %>
    <%= f.input :caption %>
  <% end %>
<% end %>
```

The `dependent_fields` helper accepts either of the following options:

```RUBY
depends_on_any: { field: value, other_field: value }
depends_on_all: { field: value, other_field: value }
depends_on_none: { field: value, other_field: value }
```

## To-Do

* Multiple select field

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/simple_form_dependent_fields. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
