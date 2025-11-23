class Product < ApplicationRecord
  has_many_attached :images, deduplicate: true

  validates :name, presence: true
end
