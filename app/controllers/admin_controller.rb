class AdminController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
  end

  def users
  end

  def agents
  end

  def reports
  end

  def payments
  end

  def analytics
  end

  private

  def authenticate_admin!
    # Mock admin authentication - in real app, implement proper admin authentication
    # redirect_to root_path unless current_user&.admin?
  end
end