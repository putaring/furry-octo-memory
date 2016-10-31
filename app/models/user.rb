class User < ActiveRecord::Base
  has_secure_password

  has_one :profile

  has_many :photos

  has_many :sent_messages, foreign_key: :sender_id, class_name: 'Message'
  has_many :received_messages, foreign_key: :recipient_id, class_name: 'Message'

  has_many :active_interests, class_name: "Interest", foreign_key: "liker_id", dependent: :destroy
  has_many :passive_interests, class_name: "Interest", foreign_key: "liked_id", dependent: :destroy

  has_many :likes, through: :active_interests,  source: :liked
  has_many :likers, through: :passive_interests, source: :liker

  enum religion: { hindu: 1, muslim: 2, christian: 3,
    sikh: 4, buddhist: 5, jain: 6, parsi: 7, jewish: 8, non_religious: 100 }

  enum status: { unmarried: 1, divorced: 2, widowed: 3 }

  enum photo_visibility: { everyone: 1, members_only: 2, restricted: 3 }

  VALID_EMAIL_REGEX     = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, length: 3..30, on: :update
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :birthdate, presence: true
  validates :gender, presence: true, length: { is: 1 }, inclusion: { in: %w(m f) }
  validates :sect, inclusion: { in: CASTES.collect { |c| c[:code] } }, allow_nil: true
  validates :religion, presence: true, inclusion: { in: User.religions.keys }
  validates :status, presence: true, inclusion: { in: User.statuses.keys }
  validates :photo_visibility, inclusion: { in: User.photo_visibilities.keys }
  validates :country, presence: true, length: { is: 2 }, inclusion: { in: ISO3166::Data.codes }
  validates :language, presence: true, length: { is: 3 }, inclusion: { in: LanguageList::POPULAR_LANGUAGES.map(&:iso_639_3) }

  validates_numericality_of :height, only_integer: true, greater_than: 24

  validates_uniqueness_of :email, case_sensitive: false,
    if: ->(u) { u.email_changed? }
  validates_uniqueness_of :username, case_sensitive: false,
    if: ->(u) { u.username_changed? }

  validate :old_enough?, if: ->(u) { (u.birthdate_changed? || u.gender_changed?) && u.birthdate.present? }

  before_validation :tweak_sect

  before_create :assign_random_username, :set_default_profile

  before_update { username.downcase! }

  before_save { email.downcase! }
  before_save { language.downcase! }

  def display_picture_for(visitor, thumbnail_type = :thumb)
    display_photos_to?(visitor) ? display_thumbnail(thumbnail_type) : default_thumbnail(thumbnail_type)
  end

  def display_thumbnail(thumbnail_type = :thumb)
    if profile_photo.present?
      profile_photo.image.url(thumbnail_type)
    else
      default_thumbnail(thumbnail_type)
    end
  end

  def about
    @_about ||= profile.about
  end

  def profile_photo
    @_profile_photo ||= photos.find_by(rank: 1)
  end

  def country_name
    @_country_name ||= ISO3166::Country.find_country_by_alpha2(country).name
  end

  def country_alpha3
    @_country_alpha3 ||= ISO3166::Country.find_country_by_alpha2(country).alpha3
  end

  def language_expanded
    @_language_expanded ||= LanguageList::LanguageInfo.find(language).name
  end

  def like(other_user)
    active_interests.create(liked_id: other_user.id)
  end

  def unlike(other_user)
    active_interests.find_by(liked_id: other_user.id).destroy
  end

  def likes?(other_user)
    likes.find_by(id: other_user.id).present?
  end

  def gender_expanded
    male? ? 'man' : 'woman'
  end

  def male?
    gender == 'm'
  end

  def female?
    gender == 'f'
  end

  def age
    now = Time.now
    now.year - birthdate.year - (birthdate.change(year: now.year) > now ? 1 : 0)
  end

  def display_photos_to?(visitor)
    @_display_photos_to ||=
    case photo_visibility
    when 'everyone' then true
    when 'members_only' then visitor.present?
    when 'restricted' then visitor.present? && (visitor.eql?(self) || likes?(visitor))
    else true
    end
  end

  def sect_long_form
    return nil if self.sect.blank?
    CASTES.find { |caste| caste[:code].eql?(self.sect) }[:name]
  end

  private
  def tweak_sect
    self.sect = nil if (self.sect.blank? || (self.religion != 'hindu'))
  end

  def old_enough?
    minimum_age = gender.eql?('m') ? 21 : 18
    errors.add(:birthdate, "indicates that you're underage. #{gender.eql?('m') ? 'Men' : 'Women'} must be at least #{minimum_age} years old.") unless birthdate <= minimum_age.years.ago
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

  def default_thumbnail(thumbnail_type = :thumb)
    image_path =  if thumbnail_type == :thumb
                    male? ? "profile_pictures/male.jpg" : "profile_pictures/female.jpg"
                  else
                    male? ? "profile_pictures/male-small.jpg" : "profile_pictures/female-small.jpg"
                  end

    ActionController::Base.helpers.asset_path(image_path)
  end
end
