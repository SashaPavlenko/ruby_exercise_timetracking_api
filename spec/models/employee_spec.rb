require "rails_helper"

RSpec.describe Employee, type: :model do
  it "is valid with a name and hourly rate" do
    employee = Employee.new(name: "Alexander", hourly_rate: 50)
    expect(employee).to be_valid
  end

  it "is invalid without a name" do
    employee = Employee.new(hourly_rate: 50)
    expect(employee).not_to be_valid
  end

  it "is invalid without an hourly rate" do
    employee = Employee.new(name: "Alexander")
    expect(employee).not_to be_valid
  end

  it "is invalid with a zero or negative hourly rate" do
    employee = Employee.new(name: "Alexander", hourly_rate: 0)
    expect(employee).not_to be_valid
  end
end
