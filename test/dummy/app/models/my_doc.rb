require 'active_model'

class MyDoc
  include ActiveModel::Model
  attr_accessor :doc_type, :text, :title, :has_title, :caption
end
