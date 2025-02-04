class Product < ApplicationRecord
  belongs_to :brand
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  validates :name, presence: true
end
