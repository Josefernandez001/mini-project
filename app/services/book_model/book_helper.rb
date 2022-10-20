module BookHelper
  def author_exists
    author = {first_name: @author_first_name, last_name: @author_last_name, age: @author_age}
    return @author = Author.create(author) unless Author.exists?(author)
    return @author = Author.find_by(author)
  end

  def find_book
    @book = Book.find_by(id: @id)
    return @book
  end
end
