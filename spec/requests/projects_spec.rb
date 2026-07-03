require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:employee) { Employee.create!(name: "Test", hourly_rate: 50) }
  let(:project) { Project.create!(name: "Test Project") }

  describe "GET /projects/:id" do
    it "returns project with total cost" do
      TimeEntry.create!(
        employee: employee,
        project: project,
        started_at: "2024-01-15T09:00:00",
        ended_at: "2024-01-15T11:00:00",  # 2 hours
        hourly_rate_snapshot: 50           # 2 * 50 = 100
      )

      get "/projects/#{project.id}",
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["total_cost"]).to eq(100.0)
    end
  end
end