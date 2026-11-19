class Link < ApplicationRecord
  # Visitors open these addresses straight from a public page, so anything but a plain web or email address is refused
  WEB_ADDRESS = %r{\Ahttps?://[^\s/?#@:]+(:\d+)?([/?#]\S*)?\z}i
  EMAIL_ADDRESS_PREFIX = "mailto:"

  belongs_to :page, touch: true

  normalizes :name, with: ->(name) { name.strip }
  normalizes :url, with: ->(url) do
    address = url.strip

    if address.match?(/\Ahttps?:\/\//i) || address.start_with?(EMAIL_ADDRESS_PREFIX)
      address
    elsif address.match?(URI::MailTo::EMAIL_REGEXP)
      "#{EMAIL_ADDRESS_PREFIX}#{address}"
    else
      "https://#{address}"
    end
  end

  validates :name, presence: true, length: { maximum: 80 }
  validates :url, presence: true, length: { maximum: 2000 }
  validate :url_is_a_web_or_email_address

  before_create :place_last

  private

  def url_is_a_web_or_email_address
    return if url.blank? || url.match?(WEB_ADDRESS) || email_address?

    errors.add(:url, "must be a web address or an email address")
  end

  def email_address?
    url.start_with?(EMAIL_ADDRESS_PREFIX) && url.delete_prefix(EMAIL_ADDRESS_PREFIX).match?(URI::MailTo::EMAIL_REGEXP)
  end

  def place_last
    self.position = page.links.reorder(nil).maximum(:position).to_i + 1
  end
end
