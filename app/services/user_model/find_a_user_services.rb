# UserModel::FindAUserServices
module UserModel
  class FindAUserServices < ApplicationService

    def initialize(username)
      @username = username
    end

    def call
      find_by_name
    end

    private

    def find_by_name
      User.find_by(username: @username)
    end

  end
end