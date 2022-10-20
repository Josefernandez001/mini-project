class BookSerializer < ActiveModel::Serializer
  attributes :title
  belongs_to :author, serializer: AuthorSerializer
  def author_id
    object.author_id
  end
end
