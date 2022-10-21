class Api::V1::AuthenticationController < ApplicationController
  class AuthenticationError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_misiing
  rescue_from AuthenticationError, with: :handle_unauthenticated

  def create
    return render json: {message: 'user not found'}, status: :unauthorized if user.nil?

    token = AuthenticateModel::AuthenticateCreator.call(user,params.require(:password))

    raise AuthenticationError unless token

    render json: token, status: :created
  end

  private

  def user
    @user ||= UserModel::FindAUserServices.call(params.require(:username))
  end

  def parameter_misiing(e)
   render json: {mesagge: e.message}, status: :unprocessable_entity
  end

  def handle_unauthenticated(e)
   head :unauthorized
  end

end
