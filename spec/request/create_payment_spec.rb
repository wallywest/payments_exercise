require "rails_helper"

RSpec.describe "Loan Payments", :type => :request do
  let(:loan) {Loan.create!(funded_amount: 1100.0)}

  it "pays off the loan do" do
    get "/loans/#{loan.id}"

    expect(response).to have_http_status(:ok)

    10.times do |i|
      post "/loans/#{loan.id}/payments", {payment: {amount: 100.0}}
      expect(response).to have_http_status(:created)
    end

    get "/loans/#{loan.id}"

    expect(response).to have_http_status(:ok)
    resource = JSON.parse(response.body)
    expect(resource["outstanding_balance"]).to eql("100.0")
    expect(resource["payments"].size).to eql(10)
  end

end
