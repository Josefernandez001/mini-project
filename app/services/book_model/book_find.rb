require_relative 'book_helper'
module BookModel
  class BookFind < ApplicationService
    include BookHelper

    def initialize(id)
      @id = id
    end

    def call
      book = find_book
      return book
    end

  end
end