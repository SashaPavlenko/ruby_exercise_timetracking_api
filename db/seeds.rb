# Clear existing data for idempotent seeding
TimeEntry.destroy_all
Project.destroy_all
Employee.destroy_all

alexander = Employee.create!(name: "Alexander Pavlenko", hourly_rate: 50.0)

nico = Employee.create!(name: "Nico Beispiel", hourly_rate: 100.0)
tim = Employee.create!(name: "Tim Anderebeispiel", hourly_rate: 100.0)

it_project = Project.create!(name: "Softwareentwicklung für Kundenprojekt")
pv_project = Project.create!(name: "Photovoltaikanlage Stefan Herzko")

# --------------------------------------------
# Data for IT project
# --------------------------------------------
TimeEntry.create!(
  employee: nico,
  project: it_project,
  started_at: "2026-01-15T09:00:00",
  ended_at: "2026-01-15T13:00:00",
  hourly_rate_snapshot: nico.hourly_rate
)

TimeEntry.create!(
  employee: tim,
  project: it_project,
  started_at: "2026-01-16T10:00:00",
  ended_at: "2026-01-16T14:30:00",
  hourly_rate_snapshot: tim.hourly_rate
)

# --------------------------------------------
# Data for Photo project
# --------------------------------------------
# Alexander works every weekday (09:00-17:00) from January through June,
# with his rate rising over time: 100 (Jan-Mar), 120 (Apr-May), 130 (Jun).
rate_for_month = lambda do |month|
  case month
  when 1..3 then 100.0
  when 4..5 then 120.0
  else 130.0
  end
end

(Date.new(2026, 1, 1)..Date.new(2026, 6, 30)).each do |date|
  next unless (1..5).cover?(date.wday) # Mon-Fri only

  TimeEntry.create!(
    employee: alexander,
    project: pv_project,
    started_at: date.strftime("%Y-%m-%dT09:00:00"),
    ended_at: date.strftime("%Y-%m-%dT17:00:00"),
    hourly_rate_snapshot: rate_for_month.call(date.month)
  )
end

alexander.update!(hourly_rate: rate_for_month.call(6)) # keep his current rate in sync with the latest period


puts "Seeded #{Employee.count} employees, #{Project.count} projects, #{TimeEntry.count} time entries"
