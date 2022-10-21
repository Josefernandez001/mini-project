# UserModel::FindAUserById
module UserModel
  class FindAUserById < ApplicationService

    def initialize(id)
      @id = id
    end

    def call
      find_by_id
    end

    private

    def find_by_id
      User.find(@id)
    end

  end
end