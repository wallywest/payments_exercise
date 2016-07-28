class CreatePayment
  InvalidPayment = Class.new(StandardError)

  def call(loan_params: nil, payment_params: {})
    Loan.transaction do
      loan = Loan.lock.find(loan_params)
      payment = Payment.new(payment_params)
      if loan.valid_payment?(payment)
        loan.payments << payment
        payment
      else
        raise InvalidPayment
      end
    end
  end

end
