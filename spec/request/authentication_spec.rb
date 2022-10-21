require 'rails_helper'

describe 'Authentication', type: :request do
  describe "POST /authenticate" do
    let(:user){ FactoryBot.create(:user) }
    it 'authenticates the client' do
      post '/api/v1/authenticate', params: {username: user.username, password: '123456'}

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          'token' => 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.kK4OImFfNUEiTyj5uGl00buwlyITPJQHKBzpeRH6lOM'
        }
      )
    end

    it 'returns errors when username is missing' do
      post '/api/v1/authenticate', params: { password: '123456' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "mesagge" => "param is missing or the value is empty: username"
        }
      )
    end

    it 'returns errors when password is missing' do
      post '/api/v1/authenticate', params: { username: 'skyfall' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq(
        {
          "mesagge" => "param is missing or the value is empty: password"
        }
      )
    end

    it 'returns errors when password is incorrect' do
      post '/api/v1/authenticate', params: { username: user.username, password: '1234'}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end