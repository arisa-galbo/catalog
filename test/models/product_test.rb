require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @brand = brands(:one)
    @product = Product.new(name: "Test Product", price: 100.0, body: "This is a test product.", production_started_on: "2025-01-01", brand: @brand)
  end

  test "有効な商品を保存可能" do
    assert @product.save, "有効な商品が保存されなかった"
  end

  test "商品名なしの商品は保存不可" do
    @product.name = nil
    assert_not @product.save, "商品名なしの商品が保存されてしまった"
  end

  test "価格が負の値の場合は保存不可" do
    @product.price = -100.0
    assert_not @product.save, "価格が負の商品が保存されてしまった"
  end

  test "価格が0の場合は保存不可" do
    @product.price = 0
    assert_not @product.save, "価格が0の商品が保存されてしまった"
  end

  test "価格がnullの場合は保存可能" do
    @product.price = nil
    assert @product.save, "価格がnullの商品が保存できなかった"
  end

  test "本文なしの商品は保存可能" do
    @product.body = nil
    assert @product.save, "本文なしの商品が保存できなかった"
  end

  test "製造開始日なしの商品は保存可能" do
    @product.production_started_on = nil
    assert @product.save, "製造開始日なしの商品が保存できなかった"
  end

  test "ブランドなしの商品は保存不可" do
    @product.brand = nil
    assert_not @product.save, "ブランドなしの商品が保存されてしまった"
  end

  test "存在しないブランドの商品は保存不可" do
    @product.brand_id = 99999
    assert_not @product.save, "DBに存在しないブランドの商品が保存されてしまった"
  end

  test "商品にブランドが登録できている" do
    @product.save
    assert_equal @brand, @product.brand, "商品にブランドが正しく保存されていない"
  end

  test "商品にタグが追加されている" do
    tag = tags(:one)
    @product.save!
    product_tag = @product.product_tags.create!(tag: tag, valid_from: "2025-01-01", valid_to: "2025-12-31")
    assert_includes @product.reload.tags, tag, "商品にタグが正しく追加されなかった"
  end

  test "商品が削除されたとき、関連する ProductTag も削除される" do
    assert_difference("ProductTag.count", -1) do
      product = products(:one)
      product.destroy
    end
  end

  test "商品が削除されても Brand は削除されない" do
    assert_no_difference("Brand.count") do
      product = products(:one)
      product.destroy
    end
  end

end
