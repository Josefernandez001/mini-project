require 'net/http'

class Api::V1::BooksController  < ApplicationController
  MAX_PAGINATION_LIMIT = 100

  def index
    books = Book.limit(limit).offset(params[:offset])
    render json: books, each_serializer: BookSerializer, status: :ok
  end

  def show
		@book = BookModel::BookFind.call(params[:id])

    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    return render json:  @book, each_serializer: BookSerializer, status: :ok
  end

  def create
    BookWorker.perform_async(
      book_params[:title], author_params[:first_name],
      author_params[:last_name], author_params[:age]
    )

    book = BookModel::BookInstance.call(
      book_params[:title], author_params[:first_name],
      author_params[:last_name], author_params[:age]
    )

    return render json: book.errors, status: :unprocessable_entity unless book.valid?

    render json: book , serializer: BookSerializer

  end


  def update
    @book = BookModel::BookUpdate.call(
      params[:id], book_params[:title],
      author_params[:first_name], author_params[:last_name],
      author_params[:age]
    )

    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    return render json: { mesagge: 'wrong data', errors: @book.errors }, status: :bad_request if @book.errors.size > 0

    render json: @book, each_serializer: BookSerializer, status: :accepted

  end

  def destroy
    @book = BookModel::BookDelete.call(params[:id])

    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    render json: {mesagge:'delete sucesfully'}, status: :no_content  if @book.destroyed?
  end

  private

  def limit
    [
      params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
      MAX_PAGINATION_LIMIT
    ].min
  end


  def book_params
    params.require(:book).permit(:title)
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :age)
  end

end

