class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by username: params[:username]

    if user && user.authenticate(params[:password]) && !user.iced
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    elsif user.iced
      redirect_to :back, notice: 'Your account is frozen, please contact admin'
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  def create_oauth
    user = User.find_by username: env["omniauth.auth"].info.nickname

    if user.nil?
      user = User.create
      user.username = env["omniauth.auth"].info.nickname
      user.password = user.password_confirmation = SecureRandom.urlsafe_base64(n=6)
      user.admin = false
      user.save
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome!"
    elsif user && !user.iced
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    elsif user.iced
      redirect_to :back, notice: 'Your account is frozen, please contact admin'
    end

  end
end