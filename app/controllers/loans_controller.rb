class LoansController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    loans = Loan.all

    render json: loans, each_serializer: LoanSerializer
  end

  def show
    render json: Loan.find(params[:id])
  end
end
