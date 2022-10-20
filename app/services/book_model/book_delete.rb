require_relative 'book_helper'
module BookModel
  class BookDelete < ApplicationService
    include BookHelper

    def initialize(id)
      @id = id
    end

    def call
      delete_book
    end

    private

    def delete_book
      @book = find_book
      @book.destroy unless @book.nil?
    end
  end
end