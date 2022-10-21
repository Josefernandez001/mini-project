module AuthenticateModel
  class AuthenticateCreator < ApplicationService
    HMAC_SECRET = "123"
    ALGORITHM_TYPE = 'HS256'

    def initialize(user, password)
      @user = user
      @password = password
    end

    def call
      create_authenticate
    end

    private

    def create_authenticate
      return false unless @user.authenticate(@password)

      payload = { user_id: @user.id }

      token = JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE

      return {token: token}
    end

  end
end