class Page < ApplicationRecord
  AVATAR_CONTENT_TYPES = %w[image/png image/jpeg image/webp image/gif].freeze
  AVATAR_MAX_BYTE_SIZE = 5.megabytes

  # Pages from before the one-page-per-account rule can lack an owner until one is assigned by hand
  belongs_to :user, optional: true
  has_many :links, -> { order(:position) }, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [ 300, 300 ]
  end

  normalizes :handle, with: ->(handle) { handle.parameterize }
  normalizes :name, :bio, with: ->(text) { text.strip }
  normalizes :color, with: ->(color) { color.strip.downcase }

  validates :handle, presence: true, uniqueness: true, length: { minimum: 3, maximum: 28 }
  validates :name, length: { maximum: 50 }
  validates :bio, length: { maximum: 180 }
  validates :color, format: { with: /\A#?(?:[0-9a-f]{3}|[0-9a-f]{6})\z/, message: "must be a hex color like #fff or #ffffff" }, allow_blank: true
  validate :avatar_is_a_small_image

  def title
    name.presence || "@#{handle}"
  end

  private

  def avatar_is_a_small_image
    return unless avatar.attached?

    errors.add(:avatar, "must be a PNG, JPEG, WebP or GIF image") unless AVATAR_CONTENT_TYPES.include?(avatar.content_type)
    errors.add(:avatar, "must be smaller than 5 MB") if avatar.byte_size > AVATAR_MAX_BYTE_SIZE
  end
end
