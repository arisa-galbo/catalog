require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "ブランド登録時、名前なしの保存を不可" do
    brand = Brand.new
    assert_not brand.save, "名前なしのブランドが保存されてしまった"
  end

  test "ブランド登録は名前を入力すると可能" do
    brand = Brand.new(name: "Brand Name")
    assert brand.save, "名前を入力したブランドが保存されなかった"
  end

  test "ブランド登録は重複した名前の場合不可" do
    brand = Brand.new(name: "Test Brand 1")
    brand.save
    assert_not brand.save, "重複した名前のブランドが保存されてしまった"
  end

  test "ブランドが削除されたとき、関連する商品も削除される" do
    assert_difference("Product.count", -2) do
      brand = brands(:one)
      brand.destroy
    end
  end

  test "ブランドが削除されたとき、関連する商品タグも削除される" do
    assert_difference("ProductTag.count", -1) do
      brand = brands(:one)
      brand.destroy
    end
  end
end
