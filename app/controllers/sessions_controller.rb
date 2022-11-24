class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, except: :delete

  layout "application_no_nav"

  # login_url
  def new
  end

  # authenticate the user and sign them in
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      user_session = @user.login!
      session[:current_session_id] = user_session.id

      redirect_to dashboard_url
    else
      redirect_to login_url
    end
  end

  # logs the user out
  def delete
    Current.user.logout!
    session.delete(:current_session_id)

    redirect_to root_url
  end
end