require "rails_helper"

RSpec.describe Project, type: :model do
  let(:project) { Project.create!(name: "Test Project") }
  let(:alexander) { Employee.create!(name: "Alexander", hourly_rate: 50) }
  let(:hans) { Employee.create!(name: "Hans", hourly_rate: 30) }

  it "is invalid without a name" do
    expect(Project.new).not_to be_valid
  end

  it "has zero total cost with no time entries" do
    expect(project.total_cost).to eq(0)
  end

  it "sums cost across multiple time entries and employees" do
    TimeEntry.create!(employee: alexander, project: project,
      started_at: "2026-01-15T09:00:00", ended_at: "2026-01-15T11:00:00", # 2h * 50 = 100
      hourly_rate_snapshot: alexander.hourly_rate)
    TimeEntry.create!(employee: hans, project: project,
      started_at: "2026-01-16T09:00:00", ended_at: "2026-01-16T12:00:00", # 3h * 30 = 90
      hourly_rate_snapshot: hans.hourly_rate)

    expect(project.total_cost).to eq(190.0)
  end

  it "uses the snapshotted rate, not the employee's current rate" do
    entry = TimeEntry.create!(employee: alexander, project: project,
      started_at: "2026-01-15T09:00:00", ended_at: "2026-01-15T11:00:00",
      hourly_rate_snapshot: alexander.hourly_rate) # 100

    alexander.update!(hourly_rate: 999) # rate changes after the fact

    expect(project.total_cost).to eq(100.0) # unaffected
  end
end