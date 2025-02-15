# frozen_string_literal: true

module UsesGuid
  extend ActiveSupport::Concern

  included do
    before_validation :set_guid, on: :create
    validates :guid, presence: true, uniqueness: true
  end

  def regenerate_guid!
    update!(guid: generate_guid)
  end

  private

  def set_guid
    self.guid = SecureRandom.urlsafe_base64
  end

  def generate_guid
    SecureRandom.urlsafe_base64
  end
end
