require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  #LIST
  describe '#index' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it "should return a list of payments for loan" do
      payA = Payment.create!(amount: 100.0, loan_id: loan.id)
      payB = Payment.create!(amount: 200.0, loan_id: loan.id)

      get :index, loan_id: loan.id

      expect(response).to have_http_status(:ok)
      list = JSON.parse(response.body)

      expect(list.size).to eql(2)
      expect(list.first.keys).to include("id", "loan_id", "amount", "created_at")
      expect(list.first["id"]).to eql(payA.id)
      expect(list.last["id"]).to eql(payB.id)
    end

    context "loan not found" do
      it 'responds with a 404' do
        get :index, loan_id: 10000
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  #GET
  describe '#show' do
    it "should return a payment" do
      loan = Loan.create!(funded_amount: 100.0)
      payment = Payment.create!(amount: 100.0, loan_id: loan.id)

      get :show, id: payment.id , loan_id: loan.id

      expect(response).to have_http_status(:ok)
      resource = JSON.parse(response.body)
      expect(resource.keys).to include("id","loan_id", "amount","created_at")
      expect(resource["id"]).to eql(payment.id)
    end

    context "loan not found" do 
      let(:payment) { Payment.create!(amount: 100.0) }

      it 'responds with a 404' do
        get :show, id: payment.id, loan_id: 10000
        expect(response).to have_http_status(:not_found)
      end
    end

    context "payment not found" do
      let(:loan) { Loan.create!(funded_amount: 100.0) }

      it 'responds with a 404' do
        get :show, id: 10000, loan_id: loan.id
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  #POST
  describe "#create" do
    context 'if the loan is not found' do
      it 'responds with a 404' do
        post :create, loan_id: 100000, payment: {amount: "100.0"}

        expect(response).to have_http_status(:not_found)
      end
    end

    context "payment validation" do
      it "responds with a 4xx when there is no payment amount given" do
        loan = Loan.create!(funded_amount: 100.0)

        post :create, loan_id: loan.id, payment: {}

        expect(response).to have_http_status(500)
        error = JSON.parse(response.body)
        expect(error).to_not eql({})
      end

      it "responds with a 4xx when there is no payment ammount has an invalid format" do
        loan = Loan.create!(funded_amount: 100.0)

        post :create, loan_id: loan.id, payment: {amount: -1.00}

        expect(response).to have_http_status(400)
        error = JSON.parse(response.body)
        expect(error).to_not eql({})

        post :create, loan_id: loan.id, payment: {amount: 0.00}
        expect(response).to have_http_status(400)
        error = JSON.parse(response.body)
        expect(error).to_not eql({})
      end

      it "responds with a 4xx when the payment exceeds the outstanding balance" do
        loan = Loan.create!(funded_amount: 100.0)

        post :create, loan_id: loan.id, payment: {amount: 1200.0}

        expect(response).to have_http_status(400)
        error = JSON.parse(response.body)
        expect(error).to_not eql({})
      end

    end

    it "should create a payment for the loan" do 
      loan = Loan.create!(funded_amount: 100.0)

      post :create, loan_id: loan.id, payment: {amount: 100.0}

      expect(response).to have_http_status(201)
      resource = JSON.parse(response.body)

      payment = loan.payments.last

      expect(resource["id"]).to eql(payment.id)
      expect(resource["amount"]).to eql(payment.amount.to_s)
    end
  end

end
