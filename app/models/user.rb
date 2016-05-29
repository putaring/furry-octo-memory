class User < ActiveRecord::Base
  has_secure_password

  enum religion: { hindu: 1, muslim: 2, christian: 3,
    sikh: 4, buddhist: 5, jain: 6, no_religion: 100 }

  VALID_EMAIL_REGEX     = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, length: 3..20
  validates :password, length: { minimum: 8 }
  validates :birthdate, presence: true
  validates :gender, presence: true, length: { is: 1 }, inclusion: { in: %w(m f) }
  validates :religion, presence: true, inclusion: { in: User.religions.keys }
  validates :country, presence: true, length: { is: 2 }
  validates :language, presence: true, length: { is: 2 }

  validates_uniqueness_of :email, case_sensitive: false,
    if: ->(u) { u.email_changed? }
  validates_uniqueness_of :username, case_sensitive: false,
    if: ->(u) { u.username_changed? }

  validate :old_enough?, if: ->(u) { u.birthdate_changed? }

  before_save { email.downcase! }
  before_save { username.downcase! }
  before_save { country.upcase! }
  before_save { language.downcase! }

  private

  def old_enough?
    errors.add(:birthdate, "shows you're underage") unless birthdate <= 18.years.ago
  end
end
