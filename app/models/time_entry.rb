class TimeEntry < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  validates :started_at, :ended_at, presence: true
  validate :ended_after_started
  validate :not_in_the_future

  private

  def ended_after_started
    return unless started_at && ended_at
    errors.add(:ended_at, "must be after started_at") if ended_at <= started_at
  end

  def not_in_the_future
    errors.add(:started_at, "can't be in the future") if started_at && started_at > Time.current
    errors.add(:ended_at, "can't be in the future") if ended_at && ended_at > Time.current
  end
end
