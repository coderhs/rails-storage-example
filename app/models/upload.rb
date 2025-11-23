class Upload < ApplicationRecord
  has_one_attached :file, deduplicate: false

  validates :name, presence: true
  validates :file, presence: true
end
