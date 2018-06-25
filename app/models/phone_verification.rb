class PhoneVerification < ActiveRecord::Base
  belongs_to :user

  before_validation :generate_verification_code, on: :create
  validates_presence_of :user_id, :ip

  validates :phone_number, presence: true, format: { with: /\A\+?[1-9]\d{1,14}\z/ }

  validates :code, presence: true, length: { is: 4 }, numericality: { only_integer: true }

  scope :verified, -> { where(verified: true) }

  validate :no_existing_validated_user, on: :create

  def verify!
    update_attributes!(verified: true)
    user.active!
  end

  private

  def generate_verification_code
    self.code = Random.rand(1000..9999)
  end

  def no_existing_validated_user
    errors.add(:phone_number, "is already linked to a different account") if PhoneVerification.verified.exists?(phone_number: self.phone_number)
  end
end
