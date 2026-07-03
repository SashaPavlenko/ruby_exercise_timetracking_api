class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    render json: {
      id: @project.id,
      name: @project.name,
      total_cost: @project.total_cost.round(2),
      time_entries: @project.time_entries.map do |entry|
        {
          id: entry.id,
          employee_id: entry.employee_id,
          started_at: entry.started_at,
          ended_at: entry.ended_at,
          hourly_rate_snapshot: entry.hourly_rate_snapshot
        }
      end
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end
end