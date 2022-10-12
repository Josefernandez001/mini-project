require 'net/http'

class Api::V1::BooksController  < ApplicationController
  MAX_PAGINATION_LIMIT = 100
  before_action :find_a_book, only: %i[update destroy show]
  before_action :author_exists, only: %i[create]

  def index
    books = Book.limit(limit).offset(params[:offset])
    render json: BooksRepresenter.new(books).as_json
  end

  def show
    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    return render json:  BookRepresenter.new(@book).as_json, status: :ok
  end

  def create

    book = Book.new(book_params.merge(author_id: @author.id))
    # UpdteSkuJob.perform_later(book_params[:name])

    return render json: BookRepresenter.new(book).as_json, status: :created if book.save

    render json: book.errors, status: :unprocessable_entity

  end


  def update
    author = @book.author
    author.update(author_params) unless author.eql?(author_params)

    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    return render json: BookRepresenter.new(@book).as_json, status: :accepted  if @book.update(book_params)

    render json: { mesagge: 'wrong data', errors: @book.errors }, status: :bad_request

  end

  def destroy
    return render json: {mesagge:'book not found'}, status: :bad_request if @book.nil?

    render json: {mesagge:'delete sucesfully'}, status: :no_content  if @book.destroy!
  end

  private

  def limit
    [
      params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
      MAX_PAGINATION_LIMIT
    ].min
  end

  def find_a_book
    @book = Book.find_by(id: params[:id])
  end

  def book_params
    params.require(:book).permit(:title)
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :age)
  end

  def author_exists
    return @author = Author.create(author_params) unless Author.exists?(author_params)
    @author = Author.find_by(author_params)
  end
end

