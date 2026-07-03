# Clear existing data for idempotent seeding
TimeEntry.destroy_all
Project.destroy_all
Employee.destroy_all

alice = Employee.create!(name: "Alice Schmidt", hourly_rate: 85.0)
bob = Employee.create!(name: "Bob Müller", hourly_rate: 65.0)

pv_project = Project.create!(name: "Photovoltaikanlage Stefan Herzko")
roof_project = Project.create!(name: "Dachsanierung Familie Weber")

TimeEntry.create!(
  employee: alice,
  project: pv_project,
  started_at: "2024-01-15T09:00:00",
  ended_at: "2024-01-15T13:00:00",
  hourly_rate_snapshot: alice.hourly_rate
)

TimeEntry.create!(
  employee: bob,
  project: pv_project,
  started_at: "2024-01-16T10:00:00",
  ended_at: "2024-01-16T14:30:00",
  hourly_rate_snapshot: bob.hourly_rate
)

puts "Seeded #{Employee.count} employees, #{Project.count} projects, #{TimeEntry.count} time entries"