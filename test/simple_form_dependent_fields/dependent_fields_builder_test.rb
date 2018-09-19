require 'test_helper'

describe SimpleFormDependentFields::DependentFieldsBuilder do
  let(:form) { SimpleForm::FormBuilder.new(:user, nil, ActionView::Base.new, {}) }

  it { form.must_respond_to :dependent_fields }

  describe '#dependent_fields' do
    let(:html) { form.dependent_fields(depends_on_any: { field: true }) { form.input(:to_s, as: :text) } }

    it { html.must_match(/simple_form_dependent_fields/) }
    it { html.must_match(/data-depends-on(.*)depends_on_any/) }
    it { html.must_match(/data-template-html(.*)textarea/) }
  end
end
