class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_admin, only: [:new, :create, :edit, :update, :destroy], unless: :devise_controller?

  private

  def authenticate_admin
    authenticate_user!
    redirect_to(root_url, flash: { error: "You do not have permission to access this area." }) unless current_user.admin?
  end
end