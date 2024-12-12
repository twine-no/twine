class Session < ApplicationRecord
  belongs_to :user
  belongs_to :platform, optional: true

  accepts_nested_attributes_for :user, :platform

  def onboarded?
    platform && user.first_name.present? && user.last_name.present?
  end

  def onboard_user(session_params)
    ActiveRecord::Base.transaction do
      platform = Platform.new(session_params[:platform_attributes])
      user.memberships.create!(platform: platform, role: :owner)
      update!(session_params.except(:platform_attributes).merge(platform: platform))
    rescue ActiveRecord::RecordInvalid => invalid
      raise "Raise an error to an issue tracker here and return false. Until then raise a hard error: #{invalid}"
    end
  end
end
