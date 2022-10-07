require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    let(:author){FactoryBot.create(:author)}

    before do
      FactoryBot.create(:book, title: 'life as dead', author: author)
      FactoryBot.create(:book, title: 'life as dead', author: author)
    end

    it 'should return all books..' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)).to eq(
        [
          {
            'id' => 1,
            'title' => "life as dead",
            'author_name' => "noa noone",
            'author_age' => 100
          },
          {
            'id' => 2,
            'title' => "life as dead",
            'author_name' => "noa noone",
            'author_age' => 100
          }
        ]
      )
    end
  end

  describe 'GET /books/:id' do
    let(:author){FactoryBot.create(:author)}
    let(:book){ FactoryBot.create(:book, title: 'life as dead', author: author) }

    it 'should return one book..' do
      get "/api/v1/books/#{ book.id }"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(
        {
          'id' => 1,
          'title' => "life as dead",
          'author_name' => "noa noone",
          'author_age' => 100
        }
      )
    end

    it 'should not return a book' do
      get '/api/v1/books/1'

      expect(response).to have_http_status(:bad_request)
    end

  end

  describe 'POST /books' do
    it 'should create a book' do
      headers = { "ACCEPT" => "application/json" }

      expect {
        post "/api/v1/books", params: {
          book: { title: 'the life of' },
          author: {first_name: 'noa', last_name: 'noone', age: '100'}
        }, headers: headers
      }.to change {Book.count}.from(0).to(1)

      expect(JSON.parse(response.body)).to eq(
        {
          'id' => 1,
          'title' => "the life of",
          'author_name' => "noa noone",
          'author_age' => 100
        }
      )

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
    end

    it 'should not create a book' do
      headers = { "ACCEPT" => "application/json" }

      post "/api/v1/books", params: {
        book: { title: '' },
        author: {first_name: 'noa', last_name: 'noone', age: '100'}
      }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'UPDATE /books/:id' do
    let(:author){FactoryBot.create(:author)}
    before do
      FactoryBot.create(:book, title: 'life as dead', author: author)
    end

    it 'should update a book and author' do
      headers = { "ACCEPT" => "application/json" }

      put '/api/v1/books/1', params: {
        book: { title: 'the golden enclaves' },
        author: {first_name: 'naomi', last_name: 'novik', age: 49}
      }, headers: headers

      expect(JSON.parse(response.body)).to eq(
        {
          'id' => 1,
          'title' => "the golden enclaves",
          'author_name' => "naomi novik",
          'author_age' => 49
        }
      )
      expect(response).to have_http_status(:accepted)
    end
    it 'should update a book and author' do
      headers = { "ACCEPT" => "application/json" }

      put '/api/v1/books/1', params: {
        book: { title: 'the golden enclaves' },
        author: {first_name: 'noa', last_name: 'noone', age: 100}
      }, headers: headers

      expect(JSON.parse(response.body)).to eq(
        {
          'id' => 1,
          'title' => "the golden enclaves",
          'author_name' => "noa noone",
          'author_age' => 100
        }
      )
      expect(response).to have_http_status(:accepted)
    end
  end

  describe 'DELETE /books/:id' do
    let(:author){FactoryBot.create(:author)}
    let!(:book){ FactoryBot.create(:book, title: 'life as dead', author: author) }

    it 'should delete a book' do
      expect {
        delete "/api/v1/books/#{ book.id }"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end

    it 'should dont delete a book' do
      delete '/api/v1/books/999'

      expect(response).to have_http_status(:bad_request)
    end
  end
end