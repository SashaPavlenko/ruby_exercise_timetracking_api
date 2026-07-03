# Time Tracking API

A Rails API-only application that lets employees log time entries against
projects, and lets anyone look up a project's total cost so far.

## Where to look

| Path | Purpose |
|---|---|
| `app/controllers/` | HTTP layer. Authenticates the request via the `X-Employee-Id` header (`ApplicationController`), parses params, and renders JSON. `TimeEntriesController#create` creates time entries; `ProjectsController#show` returns a project including its total cost. |
| `app/models/` | Domain logic: associations, validations, and business rules. `Employee`, `Project`, `TimeEntry`. `Project#total_cost` is where the cost calculation lives. |
| `db/seeds.rb` | Sample data for local development and manual testing — employees, projects, and time entries, including a scenario where an employee's hourly rate changes over time (see below). |
| `spec/requests/` | Integration-style tests that hit the actual HTTP endpoints end-to-end (routing → controller → model), asserting on status codes and JSON response bodies. |
| `spec/models/` | Unit tests for model validations and business logic (e.g. `total_cost` calculation) without going through HTTP. |

## Seeding data

```bash
bin/rails db:seed
```

This is reusable. It clears existing data first, so it's safe to rerun any time.

It currently creates:
- **3 employees**: Alexander Pavlenko, Nico Beispiel, Tim Anderebeispiel
- **2 projects**: "Softwareentwicklung für Kundenprojekt" (IT project) and "Photovoltaikanlage Stefan Herzko" (PV project)
- **Time entries**: a couple of one-off entries for Nico and Tim, plus a larger scenario for Alexander --- he logs a full working day (09:00-17:00) on every weekday from January through June 2026, with his hourly rate rising over time (100 in Jan-Mar, 120 in Apr-May, 130 in Jun). This is deliberately built to exercise the historical-rate logic described below with realistic volume (129 entries), not just a couple of records.

### Inspecting the seeded data

Start a console with `bin/rails console`, then:

```ruby
Employee.all
```
Returns the 3 seeded employees. Alexander's `hourly_rate` shows `130`, his current rate after all the raises seeded above (older entries still keep their own rate, see below).

```ruby
Project.all
```
Returns the 2 seeded projects.

```ruby
TimeEntry.where(employee: Employee.find_by(name: "Alexander Pavlenko")).count
```
`=> 129` — one entry per weekday between January and June 2026.

```ruby
Project.find_by(name: "Softwareentwicklung für Kundenprojekt").total_cost
```
`=> 116210.0` — the IT project's total cost, summed from all its time entries (Alexander's 129 plus Nico's and Tim's).

The same data can also be inspected through the actual API (`GET /projects/:id` with an `X-Employee-Id` header), which is closer to how the mobile app would use it.

## Running tests

```bash
bundle exec rspec
```

What's covered:
- **`spec/models/`** — validations on `Employee`, `Project`, `TimeEntry` (presence, `hourly_rate > 0`, `ended_at` after `started_at`, entries can't be dated in the future); `Project#total_cost` summing correctly across multiple entries and multiple employees, including the case where a rate change shouldn't affect already-created entries.
- **`spec/requests/`** — `POST /time_entries` (successful creation, validation errors, missing/invalid `X-Employee-Id` → 401); `GET /projects/:id` (returns total cost, 404 for unknown project, 401 without auth).

#### Special (detailed) test: `"sums cost correctly when one employee's rate is constant and another's changes over time"`

(`spec/requests/projects_spec.rb`)

This is the test that specifically protects the historical-rate behavior described above. It:
1. Creates a project and two employees — Alexander, whose rate never changes, and Hans, whose rate starts at 100.
2. Posts a time entry for Alexander, and a couple of entries for Hans while his rate is still 100.
3. Calls `hans.update!(hourly_rate: 200)`, then posts more entries for Hans — now made *after* the raise.
4. Repeats the raise once more (`hourly_rate: 300`) and posts a final batch of entries.
5. Fetches the project and asserts `total_cost` equals the sum of each period's hours × the rate that was in effect *at the time*, not Hans's final rate.

It works because `TimeEntriesController#create` copies the employee's *current* rate into `TimeEntry#hourly_rate_snapshot` at creation time. Later changes to `Employee#hourly_rate` don't touch entries that already exist. If that snapshot mechanism were removed and `total_cost` read `employee.hourly_rate` directly instead, this test would fail — it would overcharge for Hans's earlier work at his final (higher) rate. That's exactly the regression this test is meant to catch.

## Limitations & possible improvements

- **No time entries in the future.** Added a validation (`TimeEntry#not_in_the_future`) so `started_at`/`ended_at` can't be later than NOW. It felt like a sensible real-world constraint. Easy to remove (`validate :not_in_the_future` in `app/models/time_entry.rb`) if it turns out to be unwanted.
- **`total_cost` is rounded to 2 decimals.** rounding in `Project#total_cost` avoids surfacing that noise to API consumers.
- **(Salary) Rate changes are never change.** The assumption is that once a time entry is created, its `hourly_rate_snapshot` is fixed.
- **Notifications were discussed but out of scope.** Mailing/notifications aren't implemented.