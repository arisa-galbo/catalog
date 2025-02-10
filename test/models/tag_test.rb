require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "タグ登録時、名前なしの保存を不可" do
    tag = Tag.new
    assert_not tag.save, "名前なしのタグが保存されてしまった"
  end

  test "タグ登録は名前を入力すると可能" do
    tag = Tag.new(name: "Tag Name")
    assert tag.save, "名前を入力したタグが保存されなかった"
  end

  test "タグ登録は重複した名前の場合も可能" do
    tag = Tag.new(name: "Test Tag 3")
    assert tag.save, "重複した名前のタグが保存されてしまった"
  end

  test "タグが削除されたとき、該当する商品とタグの関連も削除される" do
    assert_difference("ProductTag.count", -1) do
      tag = tags(:one)
      tag.destroy
    end
  end

  test "タグが削除されたとき、関連する商品自身は削除されない" do
    assert_no_difference("Product.count") do
      tag = tags(:one)
      tag.destroy
    end
  end
end
