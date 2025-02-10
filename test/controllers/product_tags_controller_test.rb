require "test_helper"

class ProductTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @tag1 = tags(:one)
    @tag2 = tags(:two)
    @user = users(:one)
    @product_tag = product_tags(:one)
  end

  test "未認証ユーザーは商品にタグを追加不可" do
    assert_no_difference("ProductTag.count") do
      post product_product_tags_url(@product), params: { product_tag: { tag_id: @tag2.id, valid_from: "2025-02-01"} }
    end
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品にタグを追加可能" do
    log_in_as(@user, "password")
    assert_difference("ProductTag.count", 1) do
      post product_product_tags_url(@product), params: { product_tag: { tag_id: @tag2.id, valid_from: "2025-02-01"} }
    end
    assert_redirected_to product_url(@product)
  end

  test "未認証ユーザーは商品のタグを更新不可" do
    patch product_product_tag_url(@product, @product_tag), params: { product_tag: { tag_id: @tag2.id, valid_from: "2025-02-01"} }
    assert_redirected_to new_session_url
    @product_tag.reload
    assert_equal @tag1.id, @product_tag.tag_id, "未認証ユーザがタグを更新"
  end

  test "認証ユーザーは商品のタグを更新可能" do
    log_in_as(@user, "password")
    patch product_product_tag_url(@product, @product_tag), params: { product_tag: { tag_id: @tag2.id, valid_from: "2025-02-01"} }
    assert_redirected_to product_url(@product), "リダイレクト先が不正"
    @product_tag.reload
    assert_equal @tag2.id, @product_tag.tag_id, "タグが正しく更新されていません"
  end

  test "未認証ユーザーは商品のタグを削除不可" do
    assert_no_difference("ProductTag.count", "未認証ユーザが削除を実行") do
      delete product_product_tag_url(@product, @product_tag)
    end
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品のタグを削除可能" do
    log_in_as(@user, "password")
    assert_difference("ProductTag.count", -1, "削除数が正しくない") do
      delete product_product_tag_url(@product, @product_tag)
    end
    assert_redirected_to product_url(@product)
  end

  test "存在しないタグを商品に追加不可" do
    log_in_as(@user, "password")
    assert_no_difference("ProductTag.count") do
      post product_product_tags_url(@product), params: { product_tag: { tag_id: 999, valid_from: "2025-02-01"} }
    end
    assert_response :unprocessable_entity
  end

  test "存在しない商品のタグを更新不可" do
    log_in_as(@user, "password")
    patch product_product_tag_url(Product.last.id + 1, @product_tag), params: { product_tag: { tag_id: @tag2.id, valid_from: "2025-02-01"} }
    assert_response :not_found
  end
end
