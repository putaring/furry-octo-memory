class PhoneVerification < ActiveRecord::Base
  belongs_to :user

  before_validation :generate_verification_code, on: :create
  validates_presence_of :user_id, :ip

  validates :phone_number, presence: true, format: { with: /\A\+?[1-9]\d{1,14}\z/ }

  validates :code, presence: true, length: { is: 4 }, numericality: { only_integer: true }

  scope :verified, -> { where(verified: true) }

  validate :no_existing_validated_user, on: :create

  def send_code
    response = JSON.parse(Net::HTTP.get URI("#{Rails.application.config.otp_api_url}#{phone_number}/#{code}"))
    update_attributes(session_id: response["Details"]) if response["Status"].eql?("Success")
  end

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
