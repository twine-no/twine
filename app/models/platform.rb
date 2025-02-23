class Platform < ApplicationRecord
  has_many :users, through: :memberships
  has_many :sessions, dependent: :delete_all
  has_many :groups, dependent: :delete_all
  has_many :memberships, dependent: :destroy
  has_many :meetings, dependent: :delete_all
  has_many :links, dependent: :destroy

  enum :category, { unorganised: "unorganised", shareholder_org: "shareholder_org", member_org: "member_org" }

  scope :listed, -> { where(listed: true) }

  normalizes :name, :tagline, with: ->(string) { string.strip }
  normalizes :shortname, with: ->(shortname) { shortname.parameterize }

  before_validation :generate_shortname, on: :create
  validates :shortname, uniqueness: true, length: { minimum: 3, maximum: 28 }, presence: true
  validates :tagline, length: { maximum: 180 }
  validates :name, length: { minimum: 3, maximum: 50 }, presence: true

  has_one_attached :logo do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [ 300, 300 ]
  end

  def full_url(hostname)
    "#{hostname}/@#{shortname}"
  end

  private

  def generate_shortname
    generated_shortname = name.parameterize.gsub("-", "")
    if Platform.exists?(shortname: generated_shortname)
      self.shortname = "#{generated_shortname}-#{SecureRandom.urlsafe_base64(5)}"
    else
      self.shortname = generated_shortname
    end
  end
end
