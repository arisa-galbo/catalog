class Product < ApplicationRecord
  belongs_to :brand
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  validates :name, presence: true
  validates :brand_id, presence: true
  validates :price, numericality: { greater_than: 0, message: "を設定する場合には正の数としてください"}, allow_nil:true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "は有効なURLを入力してください" }
end
