class ApplicationController < ActionController::API
  before_action :authenticate_employee

  private

  def authenticate_employee
    @current_employee = Employee.find_by(id: request.headers["X-Employee-Id"])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_employee
  end
end