class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  validates :validity, presence: true
end
