class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  delegate :platform, to: :session, allow_nil: true
  delegate :membership, to: :session, allow_nil: true
end
