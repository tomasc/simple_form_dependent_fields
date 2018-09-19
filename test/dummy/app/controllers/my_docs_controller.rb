class MyDocsController < ApplicationController
  def new
    @my_doc = MyDoc.new
  end
end
