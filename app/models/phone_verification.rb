class PhoneVerification < ActiveRecord::Base
  belongs_to :user

  before_create :generate_verification_code
  validates_presence_of :user_id, :ip

  validates :phone_number, presence: true, format: { with: /\A\+?[1-9]\d{1,14}\z/ }

  validates :code, presence: true, length: { is: 4 }, numericality: { only_integer: true }

  private

  def generate_verification_code
    self.code = Random.rand(1000..9999)
  end
end
