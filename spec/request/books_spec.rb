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
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            "author"=>{
              "age"=>100, "first_name"=>"noa",
              "last_name"=>"noone"
            },
            "title"=>"life as dead"
          },
          {
            "author"=>{
              "age"=>100, "first_name"=>"noa",
              "last_name"=>"noone"
            },
            "title"=>"life as dead"
          }
        ]
      )
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: { limit: 1 }
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "author"=>{
              "age"=>100, "first_name"=>"noa",
              "last_name"=>"noone"
            },
          "title"=>"life as dead"
          }
        ]
      )
    end

    it 'returns a subset of books based on limit and offset ' do
      get '/api/v1/books', params: { limit: 1, offset: 1}
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            "author"=>{
              "age"=>100, "first_name"=>"noa",
              "last_name"=>"noone"
            },
            "title"=>"life as dead"
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
      expect(response_body).to eq(
        {
          "author"=>{
            "age"=>100, "first_name"=>"noa",
            "last_name"=>"noone"
          },
          "title"=>"life as dead"
        }
      )
    end

    it 'should not return a book' do
      get '/api/v1/books/1'

      expect(response).to have_http_status(:bad_request)
    end

  end

  describe 'POST /books' do

    let!(:user){FactoryBot.create(:user)}
    it 'should create a book' do
      headers = {
        "ACCEPT" => "application/json",
        "Authorization" => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
      }

      expect {
        post "/api/v1/books", params: {
          book: { title: 'the life of' },
          author: {first_name: 'noa', last_name: 'noone', age: '100'}
        }, headers: headers
      }.to change {Book.count}.from(0).to(1)

      expect(response_body).to eq(
        {"author"=>{"age"=>100, "first_name"=>"noa", "last_name"=>"noone"}, "title"=>"the life of"}
      )

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(Author.count).to eq(1)
    end

    it 'should not create a book' do
      headers = {
        "ACCEPT" => "application/json",
        "Authorization" => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
      }

      post "/api/v1/books", params: {
        book: { title: '' },
        author: {first_name: 'noa', last_name: 'noone', age: '100'}
      }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'UPDATE /books/:id' do
    let(:author){FactoryBot.create(:author)}
    let!(:user){FactoryBot.create(:user)}
    before do
      FactoryBot.create(:book, title: 'life as dead', author: author)
    end

    it 'should update a book and author' do
      headers = {
        "ACCEPT" => "application/json",
        "Authorization" => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
      }

      put '/api/v1/books/1', params: {
        book: { title: 'the golden enclaves' },
        author: {first_name: 'naomi', last_name: 'novik', age: 45}
      }, headers: headers

      expect(response_body).to eq(
        {"author"=>{"age"=>45, "first_name"=>"naomi", "last_name"=>"novik"}, "title"=>'the golden enclaves'}

      )
      expect(response).to have_http_status(:accepted)
    end
    it 'should update a book and author' do
      headers = {
        "ACCEPT" => "application/json",
        "Authorization" => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
      }

      put '/api/v1/books/1', params: {
        book: { title: 'the golden enclaves' },
        author: {first_name: 'noa', last_name: 'noone', age: 100}
      }, headers: headers

      expect(response_body).to eq(
        {"author"=>{"age"=>100, "first_name"=>"noa", "last_name"=>"noone"}, "title"=>'the golden enclaves'}
      )
      expect(response).to have_http_status(:accepted)
    end
  end

  describe 'DELETE /books/:id' do
    let(:author){FactoryBot.create(:author)}
    let!(:user){FactoryBot.create(:user)}
    let!(:book){ FactoryBot.create(:book, title: 'life as dead', author: author) }
    headers = {
      "ACCEPT" => "application/json",
      "Authorization" => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
    }

    it 'should delete a book' do

      expect {
        delete "/api/v1/books/#{ book.id }", headers: headers
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end

    it 'should dont delete a book' do

      delete '/api/v1/books/999', headers: headers

      expect(response).to have_http_status(:bad_request)
    end
  end
end