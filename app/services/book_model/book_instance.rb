require_relative 'book_helper'
module BookModel
  class BookInstance < ApplicationService
    include BookHelper

    def initialize(title, first_name, last_name, age)
      @title = title
      @author_first_name = first_name
      @author_last_name = last_name
      @author_age = age
    end

    def call
      book_instance
    end

    private

    def book_instance
      author_exists
      @book = Book.new(title: @title, author_id: @author.id)
    end
  end
end