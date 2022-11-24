class UsersController < ApplicationController
  before_action :redirect_if_logged_in

  layout "application_no_nav"

  # signup_url
  def new
    @user ||= User.new
  end

  # create user and sign them in
  def create
    @user = User.create(user_create_params)
    if @user.save
      user_session = @user.login!
      session[:current_session_id] = user_session.id

      respond_to do |format|
        format.turbo_stream { redirect_to dashboard_url, target: "_top" }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            @user,
            partial: "users/form",
            locals: {user: @user}
          )}
      end
    end
  end

  def user_create_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end