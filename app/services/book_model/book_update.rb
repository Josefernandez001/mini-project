require_relative 'book_helper'
module BookModel
  class BookUpdate < ApplicationService
    include BookHelper

    def initialize(id, title, first_name, last_name, age)
      @id = id
      @title = title
      @author_first_name = first_name
      @author_last_name = last_name
      @author_age = age
    end

    def call
      update_book
    end

    private

    def author_update
      author_params = {first_name: @author_first_name, last_name: @author_last_name, age: @author_age}
      @book = find_book
      @author = @book.author
      @author.update(author_params) unless Author.exists?(author_params)
    end

    def update_book
      author_update
      @book.update(title: @title, author_id: @author.id)
      return @book
    end
  end
end