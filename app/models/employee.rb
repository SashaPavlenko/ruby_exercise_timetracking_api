class Employee < ApplicationRecord
  has_many :time_entries
  validates :name, presence: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }
end
