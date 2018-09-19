require 'test_helper'

describe 'Dependent Fields', :capybara do
  before do
    visit '/'
    select_doc_type('image')
  end

  it { page.must_have_selector 'div.simple_form_dependent_fields' }

  describe 'depends_on_any' do
    it 'shows dependent fields when selecting an option in a select', js: true do
      page.wont_have_selector '.input.my_doc_text'
      select_doc_type('text')
      page.must_have_selector '.input.my_doc_text'
    end
  end

  describe 'depends_on_all' do
    it 'shows a dependent field when clicking checkbox', js: true do
      page.wont_have_selector '.input.my_doc_title'
      select_doc_type('text')
      find(:css, 'input#my_doc_has_title').click
      page.must_have_selector '.input.my_doc_title'
    end
  end

  describe 'depends_on_none' do
    it 'shows dependent fields when selecting an option in a select', js: true do
      page.must_have_selector '.input.my_doc_caption'
      select_doc_type('text')
      page.wont_have_selector '.input.my_doc_caption'
      select_doc_type('video')
      page.must_have_selector '.input.my_doc_caption'
    end
  end

  private

  def select_doc_type(doc_type)
    find(:css, 'select#my_doc_doc_type').find(:option, doc_type).select_option
  end
end
