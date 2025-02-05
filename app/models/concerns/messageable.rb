module Messageable
  extend ActiveSupport::Concern

  included do
    has_many :messages, as: :messageable

    scope :messaged, -> { where.associated(:messages) }
    scope :not_messaged, -> { where.missing(:messages) }
  end
end
