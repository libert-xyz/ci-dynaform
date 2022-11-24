class DashboardController < ApplicationController
  before_action :redirect_if_not_logged_in
  def index
    @dyna_forms = Current.user.dyna_forms
    @dyna_form = DynaForm.new
  end
end