require 'rails_helper'

RSpec.describe Loan, type: :model do

  context "no payments" do
    let(:loan) {Loan.create!(funded_amount: 1000.0)}

    it "should return the existing payment total" do
      expect(loan.outstanding_balance).to eql(loan.funded_amount)
    end
  end

  context "valid payments" do
    let(:loan) {Loan.create!(funded_amount: 1000.0)}
    let(:paymentA) {Payment.create!(amount: 10.0)}
    let(:paymentB) {Payment.create!(amount: 100.0)}
    let(:paymentC) {Payment.create!(amount: 10.002)}
    let(:paymentD) {Payment.create!(amount: 879.998)}

    it "should add a payment to the loan" do
      payment = loan.add_payment(paymentA)
      expect(payment.loan_id).to eql(loan.id)
      expect(loan.outstanding_balance).to eql(990.0)

      payment = loan.add_payment(paymentB)
      expect(payment.loan_id).to eql(loan.id)
      expect(loan.outstanding_balance).to eql(890.0)

      payment = loan.add_payment(paymentC)
      expect(payment.loan_id).to eql(loan.id)
      expect(loan.outstanding_balance).to eql(879.998)

      expect(loan.payments.size).to eql(3)

      payment = loan.add_payment(paymentD)
      expect(payment.loan_id).to eql(loan.id)
      expect(loan.outstanding_balance).to eql(0)

      expect(loan.payments.size).to eql(4)
    end
  end
  
  context "invalid payments" do
    let(:loan) {Loan.create!(funded_amount: 1000.0)}
    let(:payment) {Payment.create!(amount: 1000.002)}

    it "should not add a payment to the loan with an amount exceeding the outstanding balance" do
      result = loan.add_payment(payment)
      expect(result).to be_nil
      expect(loan.payments.size).to eql(0)
      expect(loan.outstanding_balance).to eql(loan.funded_amount)
    end

    it "should not add a payment that is invalid" do
      expect(payment).to receive(:valid?).and_return(false)
      result = loan.add_payment(payment)
      expect(result).to be_nil
      expect(loan.payments.size).to eql(0)
      expect(loan.outstanding_balance).to eql(loan.funded_amount)
    end
  end
end


