class Assessment < ApplicationRecord
  belongs_to :membership

  validates :value, presence: true, inclusion: { in: 0..100 }
end
