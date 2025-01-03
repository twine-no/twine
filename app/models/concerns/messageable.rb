module Messageable
  extend ActiveSupport::Concern

  included do
    has_many :messages, as: :messageable

    scope :messaged, -> { where.associated(:messages) }
  end
end
