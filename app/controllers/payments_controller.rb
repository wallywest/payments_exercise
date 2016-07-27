class PaymentsController < ApplicationController
  def index
    payments = Payment.where(loan_id: params[:loan_id])
    if payments.blank?
      raise ActiveRecord::RecordNotFound
    else
      render json: payments
    end
  end

  def show
    payment = Payment.where(id: params[:id], loan_id: params[:loan_id]).first
    if payment.nil?
      raise ActiveRecord::RecordNotFound
    else
      render json: payment
    end
  end

  def create
    loan = Loan.find(params[:loan_id])
    payment = Payment.new(payment_params)

    loan.add_payment(payment)

    if loan.errors.empty?
      render json: payment, status: 201
    else
      render json: loan.api_error(code: 400), status: 400
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:amount)
  end

end
