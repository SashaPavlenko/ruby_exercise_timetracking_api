require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:employee) { Employee.create!(name: "Alexander", hourly_rate: 50) }
  let(:project) { Project.create!(name: "Test Project") }

  describe "GET /projects/:id" do
    it "returns project with total cost" do
      TimeEntry.create!(
        employee: employee,
        project: project,
        started_at: "2026-01-15T09:00:00",
        ended_at: "2026-01-15T11:00:00",  # 2 hours
        hourly_rate_snapshot: 50           # 2 * 50 = 100
      )

      get "/projects/#{project.id}",
        headers: { "X-Employee-Id" => employee.id }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["total_cost"]).to eq(100.0)
    end

    it "returns 404 for an unknown project" do
      get "/projects/999999", headers: { "X-Employee-Id" => employee.id }
      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without an employee header" do
      get "/projects/#{project.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "sums cost correctly when one employee's rate is constant and another's changes over time" do
      project = Project.create!(name: "Project with actively changing rate")
      alexander = Employee.create!(name: "Alexander", hourly_rate: 100)
      hans = Employee.create!(name: "Hans", hourly_rate: 100)

      create_entry = ->(employee, date) do
        post "/time_entries",
          params: { time_entry: { project_id: project.id,
            started_at: "#{date}T10:00:00", ended_at: "#{date}T20:00:00" } },
          headers: { "X-Employee-Id" => employee.id }
      end

      # Alexander: rate never changes, one day 10h * 100 = 1000
      create_entry.call(alexander, "2026-06-01")

      # Hans: rate 100 on 06.01-06.02 (2 days * 10h * 100 = 2000)
      ["2026-06-01", "2026-06-02"].each { |d| create_entry.call(hans, d) }

      # Hans: rate changes to 200, 06.03-06.05 (3 days * 10h * 200 = 6000)
      hans.update!(hourly_rate: 200)
      ["2026-06-03", "2026-06-04", "2026-06-05"].each { |d| create_entry.call(hans, d) }

      # Hans: rate changes to 300, 06.06-06.08 (3 days * 10h * 300 = 9000)
      hans.update!(hourly_rate: 300)
      ["2026-06-06", "2026-06-07", "2026-06-08"].each { |d| create_entry.call(hans, d) }

      get "/projects/#{project.id}", headers: { "X-Employee-Id" => alexander.id }
      json = JSON.parse(response.body)

      expected_total = 10*100 + 10*100*2 + 10*200*3 + 10*300*3 # 18000
      expect(json["total_cost"]).to eq(expected_total.to_f)
    end
  end
end