require 'rails_helper'

describe AuthenticateModel::AuthenticateCreator do
  describe '.call' do
    let(:user){ FactoryBot.create(:user) }
    it 'return an authenticate token' do
      token = described_class.call(user,123456)

      decode_token = JWT.decode token[:token], described_class::HMAC_SECRET, true, { algorithm: described_class::ALGORITHM_TYPE}

      expect(decode_token).to eq(
        [
          {"user_id"=>1},
          {"alg"=>"HS256"}
        ]
      )
    end
  end
end