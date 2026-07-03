require "rails_helper"

RSpec.describe "TimeEntries", type: :request do
  let(:employee) { Employee.create!(name: "Test", hourly_rate: 50) }
  let(:project) { Project.create!(name: "Test Project") }

  describe "POST /time_entries" do
    it "creates a time entry with valid data" do
      post "/time_entries",
        params: {
          time_entry: {
            project_id: project.id,
            started_at: "2024-01-15T09:00:00",
            ended_at: "2024-01-15T11:00:00"
          }
        },
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:created)
      expect(TimeEntry.count).to eq(1)
    end

    it "returns 422 with invalid data" do
      post "/time_entries",
        params: {
          time_entry: {
            project_id: project.id,
            started_at: "2024-01-15T11:00:00",
            ended_at: "2024-01-15T09:00:00"
          }
        },
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end