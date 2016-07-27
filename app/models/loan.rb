class Loan < ActiveRecord::Base
  has_many :payments

  def add_payment(payment)
    if valid_payment?(payment)
      payments << payment
    else
      errors.add(:invalid_payment, "unable to add payment to loan")
    end
  end

  def valid_payment?(payment)
    payment.valid? && (new_balance(payment) <= funded_amount)
  end

  def outstanding_balance
    funded_amount - existing_balance
  end

  def api_error(code: 500)
    {error: "", error_description: "", status_code: code}
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
