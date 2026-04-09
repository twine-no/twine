class Project < ApplicationRecord
  belongs_to :platform
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
end
