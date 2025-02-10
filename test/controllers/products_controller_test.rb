require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @product = products(:one)
    @user = users(:one)
  end

  test "商品一覧ページにアクセス可能" do
    get products_url
    assert_response :success
  end

  test "商品詳細ページにアクセス可能" do
    get product_url(@product)
    assert_response :success
  end

  test "未認証ユーザーは商品作成ページにアクセス不可" do
    get new_brand_product_url(@brand)
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品作成ページにアクセス可能" do
    log_in_as(@user, "password")
    get new_brand_product_url(@brand)
    assert_response :success
  end

  test "未認証ユーザーは商品を作成不可" do
    assert_no_difference("Product.count") do
      post brand_products_url(@brand), params: { product: { name: "New Product", price: 1000, body: "説明", production_started_on: Date.today } }
    end
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品を作成可能" do
    log_in_as(@user, "password")
    assert_difference("Product.count", 1) do
      post brand_products_url(@brand), params: { product: { name: "New Product", price: 1000, body: "説明", production_started_on: Date.today } }
    end
    assert_redirected_to product_url(Product.last)
  end

  test "未認証ユーザーは商品編集ページにアクセス不可" do
    get edit_product_url(@product)
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品編集ページにアクセス可能" do
    log_in_as(@user, "password")
    get edit_product_url(@product)
    assert_response :success
  end

  test "未認証ユーザーは商品を更新不可" do
    patch product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to new_session_url
    @product.reload
    assert_equal "Test Product 1", @product.name, "未認証ユーザーが商品を更新できている"
  end

  test "認証ユーザーは商品を更新可能" do
    log_in_as(@user, "password")
    patch product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to product_url(@product)
    @product.reload
    assert_equal "Updated Name", @product.name, "商品が更新されていません"
  end

  test "未認証ユーザーは商品を削除不可" do
    assert_no_difference("Product.count","未認証ユーザが商品を削除できた") do
      delete product_url(@product)
    end
    assert_redirected_to new_session_url
  end

  test "認証ユーザーは商品を削除可能" do
    log_in_as(@user, "password")
    assert_difference("Product.count", -1, "商品の削除された数が不正") do
      delete product_url(@product)
    end
    assert_redirected_to products_url
  end

  test "商品作成時に無効なデータを渡すと更新不可" do
    log_in_as(@user, "password")
    post brand_products_url(@brand), params: { product: { name: "", price: 1000, body: "説明", production_started_on: Date.today } }
    assert_response :unprocessable_entity
  end

  test "商品更新時に無効なデータを渡すと更新不可" do
    log_in_as(@user, "password")
    patch product_url(@product), params: { product: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "存在しない商品にアクセスするとエラーページが表示される" do
    get product_url(Product.last.id + 1)
    assert_response :not_found
  end
end
