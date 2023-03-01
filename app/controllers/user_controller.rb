class UserController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
      render json: user, status: :created
      session[:user_id] = user.id
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def show
  #   user = User.find_by(username: params[:username])
  #   if user&.authenticate(params[:password])
  #     render json: user
  #   else
  #     render json: { errors: "Not Authorized" }, status: :unauthorized
  #   end
  # end

  def show
    return render json: { errors: "Not Authorized" }, status: :unauthorized unless session.include? :user_id
    user = User.find(session[:user_id])
    render json: user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end