class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true, required: true

  enum :category, %w[email]

  has_rich_text :content

  def deliver!(mailer:)
    Rails.env.development? ? mailer.deliver_now : mailer.deliver_later
  end
end
