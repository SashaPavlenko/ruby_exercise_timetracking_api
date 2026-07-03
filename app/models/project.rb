class Project < ApplicationRecord
  has_many :time_entries
  validates :name, presence: true

  def total_cost
    time_entries.sum("(CAST((julianday(ended_at) - julianday(started_at)) * 24 AS REAL)) * hourly_rate_snapshot")
  end
end