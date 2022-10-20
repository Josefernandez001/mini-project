require_relative 'book_helper'
module BookModel
  class BookCreator < ApplicationService
    include BookHelper

    def initialize(title, first_name, last_name, age)
      @title = title
      @author_first_name = first_name
      @author_last_name = last_name
      @author_age = age
    end

    def call
      create_book
    end

    private

    def create_book
      author_exists
      @book = Book.create(title: @title, author_id: @author.id)
    end

  end
end