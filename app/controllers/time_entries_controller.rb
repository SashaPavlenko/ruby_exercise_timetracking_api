class TimeEntriesController < ApplicationController
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    @time_entry.employee = @current_employee
    @time_entry.hourly_rate_snapshot = @current_employee.hourly_rate

    if @time_entry.save
      render json: @time_entry, status: :created
    else
      render json: { errors: @time_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def time_entry_params
    params.expect(time_entry: [ :project_id, :started_at, :ended_at ])
  end
end
