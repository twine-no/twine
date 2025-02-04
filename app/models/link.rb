class Link < ApplicationRecord
  belongs_to :platform, required: true, touch: true

  broadcasts_refreshes

  normalizes :url, with: -> (url) do
    uri = URI.parse(url)
    uri.scheme.nil? ? "https://#{url}" : url
  rescue URI::InvalidURIError
    self.errors.add(:url, "Not a valid URL")
  end
end
