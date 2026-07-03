require "rails_helper"

RSpec.describe "TimeEntries", type: :request do
  let(:employee) { Employee.create!(name: "Alexander", hourly_rate: 50) }
  let(:project) { Project.create!(name: "Test Project") }

  describe "POST /time_entries" do
    it "creates a time entry with valid data" do
      post "/time_entries",
        params: {
          time_entry: {
            project_id: project.id,
            started_at: "2026-01-15T09:00:00",
            ended_at: "2026-01-15T11:00:00"
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
            started_at: "2026-01-15T11:00:00",
            ended_at: "2026-01-15T09:00:00"
          }
        },
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 422 when the time entry is in the future" do
      post "/time_entries",
        params: {
          time_entry: {
            project_id: project.id,
            started_at: 1.day.from_now,
            ended_at: 2.days.from_now
          }
        },
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 401 without an employee header" do
      post "/time_entries",
        params: { time_entry: { project_id: project.id,
          started_at: "2026-01-15T09:00:00", ended_at: "2026-01-15T11:00:00" } }

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with an unknown employee id" do
      post "/time_entries",
        params: { time_entry: { project_id: project.id,
          started_at: "2026-01-15T09:00:00", ended_at: "2026-01-15T11:00:00" } },
        headers: { "X-Employee-Id" => -1 }

      expect(response).to have_http_status(:unauthorized)
    end

    it "snapshots the current employee's hourly rate" do
      post "/time_entries",
        params: { time_entry: { project_id: project.id,
          started_at: "2026-01-15T09:00:00", ended_at: "2026-01-15T11:00:00" } },
        headers: { "X-Employee-Id" => employee.id }

      expect(TimeEntry.last.hourly_rate_snapshot).to eq(employee.hourly_rate)
    end
  end
end