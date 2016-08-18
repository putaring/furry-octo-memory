class User < ActiveRecord::Base
  has_secure_password

  has_one :profile

  enum religion: { hindu: 1, muslim: 2, christian: 3,
    sikh: 4, buddhist: 5, jain: 6, no_religion: 100 }

  VALID_EMAIL_REGEX     = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, length: 3..30, on: :update
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :birthdate, presence: true
  validates :gender, presence: true, length: { is: 1 }, inclusion: { in: %w(m f) }
  validates :religion, presence: true, inclusion: { in: User.religions.keys }
  validates :country, presence: true, length: { is: 2 }, inclusion: { in: ISO3166::Data.codes }
  validates :language, presence: true, length: { is: 3 }, inclusion: { in: LanguageList::COMMON_LANGUAGES.map(&:iso_639_3) }

  validates_uniqueness_of :email, case_sensitive: false,
    if: ->(u) { u.email_changed? }
  validates_uniqueness_of :username, case_sensitive: false,
    if: ->(u) { u.username_changed? }

  validate :old_enough?, if: ->(u) { u.birthdate_changed? }

  before_create :assign_random_username, :set_default_profile

  before_update { username.downcase! }

  before_save { email.downcase! }
  before_save { language.downcase! }

  private

  def old_enough?
    minimum_age = gender.eql?('m') ? 21 : 18
    errors.add(:birthdate, "cannot be less than #{minimum_age} years ago.") unless birthdate <= minimum_age.years.ago
  end

  def set_default_profile
    build_profile
    true
  end

  def assign_random_username
    self.username = random_username
    while User.exists?(username: self.username) do
      self.username = random_username
    end
  end

  def random_username
    "#{random_prefix}-#{random_noun}-#{SecureRandom.random_number(10000)}"[0...30]
  end

  def random_noun
    [
      Faker::Company.profession, Faker::Commerce.product_name.split.second,
      Faker::Team.creature, Faker::Commerce.product_name.split.third
    ].sample.downcase.gsub(/\s+/, "")
  end

  def random_prefix
    [
      Faker::Color.color_name, Faker::Superhero.name.split.first,
      Faker::Commerce.product_name.split.first
    ].sample.downcase.gsub(/\s+/, "")
  end

end
