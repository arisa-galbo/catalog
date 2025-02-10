require "test_helper"

class ProductTagTest < ActiveSupport::TestCase
  def setup
    @brand = brands(:one)
    @product = Product.create!(name: "Test Product", price: 100.0, body: "Test description", production_started_on: "2025-01-01", brand: @brand)
    @tag = tags(:one)
    @product_tag = ProductTag.new(product: @product, tag: @tag, valid_from: "2025-02-01", valid_to: "2025-03-01")
  end

  test "有効な product_tag を保存可能" do
    assert @product_tag.save, "有効な product_tag が保存されなかった"
  end

  test "valid_from がない場合は保存不可" do
    @product_tag.valid_from = nil
    assert_not @product_tag.save, "valid_from がないのに保存された"
    assert_includes @product_tag.errors[:valid_from], "can't be blank"
  end

  test "valid_to が valid_from より前の場合は保存不可" do
    @product_tag.valid_to = "2025-01-01"
    assert_not @product_tag.save, "valid_to が valid_from より前なのに保存されてた"
    assert_includes @product_tag.errors[:valid_to], "終了日は開始日以降の日付を入力してください"
  end

  test "同じ商品に同じタグを追加できない" do
    @product_tag.save!
    duplicate_tag = ProductTag.new(product: @product, tag: @tag, valid_from: "2025-04-01", valid_to: "2025-05-01")
    assert_not duplicate_tag.save, "同じ商品に同じタグを追加できた"
    assert_includes duplicate_tag.errors[:tag_id], "このタグはすでに追加されています"
  end

  test "valid_from, valid_toが正しくvalidityに変換される" do
    @product_tag.save!
    assert_equal "2025-02-01...2025-03-01", @product_tag.validity.to_s, "validity が正しく保存されていない"
  end

  test "validity から valid_from, valid_to を正しく取得できる" do
    @product_tag.save!
    fetched_product_tag = ProductTag.find(@product_tag.id)
    assert_equal Date.parse("2025-02-01"), fetched_product_tag.valid_from, "valid_from の値が正しくない"
    assert_equal Date.parse("2025-03-01"), fetched_product_tag.valid_to, "valid_to の値が正しくない"
  end

  test "valid_to が nil の場合、無期限の validity になる" do
    @product_tag.valid_to = nil
    @product_tag.save!
    assert_equal "2025-02-01...Infinity", @product_tag.validity.to_s, "valid_to が nil の場合の validity が正しくない"
  end

  test "ProductTag を削除すると関連データが正しく削除される" do
    @product_tag.save!
    assert_difference("ProductTag.count", -1) do
      @product_tag.destroy
    end
  end

  test "ProductTagを削除しても商品とタグ自身は削除されない" do
    @product_tag.save!
    assert_no_difference("Product.count") do
      @product_tag.destroy
    end
    assert_no_difference("Tag.count") do
      @product_tag.destroy
    end
  end
end
