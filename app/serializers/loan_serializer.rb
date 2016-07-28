class LoanSerializer < ActiveModel::Serializer
  attributes :id, :funded_amount, :outstanding_balance

  has_many :payments
end
