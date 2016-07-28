class Loan < ActiveRecord::Base
  has_many :payments

  def valid_payment?(payment)
    payment.valid? && (new_balance(payment) <= funded_amount)
  end

  def outstanding_balance
    funded_amount - existing_balance
  end

  private 

  def new_balance(payment)
    existing_balance + payment.amount
  end

  def existing_balance
    payments.pluck(:amount).tap do |arry|
      return BigDecimal.new("0") if arry.empty?
      return arry.sum
    end
  end

end
