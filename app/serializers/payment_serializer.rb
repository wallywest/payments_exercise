class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :loan_id, :amount, :created_at
end
