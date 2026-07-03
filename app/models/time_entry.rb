class TimeEntry < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  validates :started_at, :ended_at, presence: true
  validate :ended_after_started

  private

  def ended_after_started
    return unless started_at && ended_at
    errors.add(:ended_at, "must be after started_at") if ended_at <= started_at
  end
end