module AuthenticateModel
  class AuthenticationDecode < ApplicationService
    HMAC_SECRET = "123"
    ALGORITHM_TYPE = 'HS256'

    def initialize(token)
      @token = token
    end

    def call
      decode_token
    end

    private

    def decode_token
      decode_token = JWT.decode @token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE}
      decode_token[0]['user_id']
    end

  end
end