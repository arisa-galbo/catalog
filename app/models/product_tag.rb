class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
  
  attr_accessor :valid_from, :valid_to
  validates :valid_from, presence: true
  validates :tag_id, uniqueness: { scope: :product_id, message: "このタグはすでに追加されています" }, presence: true
  validate :validate_validity_range

  before_validation :convert_dates
  before_save :format_validity_range
  after_find :convert_validity_to_dates
  private

  def convert_dates
    self.valid_from = valid_from.to_date if valid_from.present?
    self.valid_to = valid_to.to_date if valid_to.present?
  end
  def validate_validity_range
    return if valid_from.blank?
    if valid_to.present? && valid_from > valid_to
      errors.add(:valid_to, "終了日は開始日以降の日付を入力してください")
    end
  end

  def format_validity_range
    self.validity = valid_to.present? ? "[#{valid_from}, #{valid_to})" : "[#{valid_from},)"
  end
  def convert_validity_to_dates
    return if validity.blank?
    self.valid_from = validity.begin
    self.valid_to = validity.end == Float::INFINITY ? nil : validity.end
  end
end
