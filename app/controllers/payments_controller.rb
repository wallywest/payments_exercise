class PaymentsController < ApplicationController
  def index
    loan = Loan.find(loan_params)

    payments = Payment.where(loan_id: loan.id)
    render json: payments, each_serializer: PaymentSerializer
  end

  def show
    payment = Payment.where(id: params[:id], loan_id: loan_params).first

    raise ActiveRecord::RecordNotFound if payment.nil?

    render json: payment
  end

  def create
    begin
      payment = create_payment_service.(
        loan_params: loan_params, 
        payment_params: payment_params
      )

      render json: payment, status: 201
    rescue CreatePayment::InvalidPayment
      render json: api_error(code: 400, error: :bad_request, error_description: "unable to add payment"), status: 400
    end
  end

  private


  def api_error(code: 500, error: :invalid_request, error_description: "")
    {error: error, error_description: error_description, status_code: code}
  end

  def create_payment_service
    CreatePayment.new
  end

  def loan_params
    params.require(:loan_id)
  end

  def payment_params
    params.require(:payment).permit(:amount)
  end

end
