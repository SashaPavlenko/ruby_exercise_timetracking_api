require "rails_helper"

RSpec.describe TimeEntry, type: :model do
  let(:employee) { Employee.create!(name: "Alexander", hourly_rate: 50) }
  let(:project) { Project.create!(name: "Test Project") }

  it "is valid with correct attributes" do
    entry = TimeEntry.new(
      employee: employee,
      project: project,
      started_at: "2026-01-15T09:00:00",
      ended_at: "2026-01-15T11:00:00",
      hourly_rate_snapshot: 50
    )
    expect(entry).to be_valid
  end

  it "is invalid when ended_at is before started_at" do
    entry = TimeEntry.new(
      employee: employee,
      project: project,
      started_at: "2026-01-15T11:00:00",
      ended_at: "2026-01-15T09:00:00",
      hourly_rate_snapshot: 50
    )
    expect(entry).not_to be_valid
  end

    it "is invalid without an employee" do
    entry = TimeEntry.new(project: project, started_at: "2026-01-15T09:00:00",
      ended_at: "2026-01-15T11:00:00", hourly_rate_snapshot: 50)
    expect(entry).not_to be_valid
  end

  it "is invalid without a project" do
    entry = TimeEntry.new(employee: employee, started_at: "2026-01-15T09:00:00",
      ended_at: "2026-01-15T11:00:00", hourly_rate_snapshot: 50)
    expect(entry).not_to be_valid
  end

  it "is invalid without started_at or ended_at" do
    entry = TimeEntry.new(employee: employee, project: project, hourly_rate_snapshot: 50)
    expect(entry).not_to be_valid
  end

  it "is invalid when started_at is in the future" do
    entry = TimeEntry.new(employee: employee, project: project,
      started_at: 1.day.from_now, ended_at: 2.days.from_now, hourly_rate_snapshot: 50)
    expect(entry).not_to be_valid
  end

  it "is invalid when ended_at is in the future" do
    entry = TimeEntry.new(employee: employee, project: project,
      started_at: Time.current, ended_at: 1.day.from_now, hourly_rate_snapshot: 50)
    expect(entry).not_to be_valid
  end
end