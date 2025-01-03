class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true

  enum :category, %w[email]
end
