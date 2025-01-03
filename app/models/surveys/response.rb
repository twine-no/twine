module Surveys
  class Response < ApplicationRecord
    belongs_to :survey
  end
end
