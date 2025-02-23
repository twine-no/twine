class Link < ApplicationRecord
  belongs_to :platform, required: true, touch: true

  default_scope { order(:position) }

  normalizes :url, with: ->(url) do
    uri = URI.parse(url)
    uri.scheme.nil? ? "https://#{url}" : url
  rescue URI::InvalidURIError
    self.errors.add(:url, "Not a valid URL")
  end

  before_validation :set_position, on: :create

  after_commit :broadcast_site_update, on: [ :create, :update, :destroy ]

  private

  def set_position
    self.position = platform.links.maximum(:position).to_i + 1
  end

  def broadcast_site_update
    Turbo::StreamsChannel.broadcast_replace_to(
      platform,
      target: "site_content",
      partial: "public/platforms/site_content",
      locals: { platform: platform }
    )
  end
end
