require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
   
    it 'responds with a list of loans' do
      loanA = Loan.create!(funded_amount: 100.0)
      loanB = Loan.create!(funded_amount: 200.0)

      get :index

      list = JSON.parse(response.body)
      expect(list.size).to eql(2)
      expect(list).to eql([])
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, id: loan.id
      expect(response).to have_http_status(:ok)
    end

    it "responds with the loan" do
      get :show, id: loan.id
      loan = JSON.parse(response.body)

      expect(loan).to eql({})
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, id: 10000
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
