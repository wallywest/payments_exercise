class Payment < ActiveRecord::Base
  validates :amount, presence: true
  validate :validate_sign_and_zero

  def validate_sign_and_zero
    if amount.sign < 0 || amount.zero?
      errors.add(:amount, "must be a positive value")
    end
  end
end
