class Payment < ActiveRecord::Base
  has_one :loan

  validates :amount, presence: true
  validate :validate_sign_and_zero
  validate :validate_cents

  def validate_sign_and_zero
    if amount.sign < 0 || amount.zero?
      errors.add(:amount, "must be a positive value")
    end
  end

  def validate_cents
    if amount < BigDecimal.new("100.0")
      errors.add(:amount, "amount must be in cents")
    end
  end

end
