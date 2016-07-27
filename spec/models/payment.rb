require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe "validations" do

    it "should not be valid with a 0 value" do
      expect(Payment.new(amount: 0.00)).to_not be_valid
    end

    it "should not be valid with a negative value" do
      expect(Payment.new(amount: -0.00)).to_not be_valid
    end

  end
end


