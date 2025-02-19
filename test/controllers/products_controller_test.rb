require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "商品一覧ページにアクセス可能" do
    get products_url
    assert_response :success
  end

  test "商品詳細ページにアクセス可能" do
    get product_url(@product)
    assert_response :success
  end

  test "存在しない商品にアクセスするとエラーページが表示される" do
    get product_url(Product.last.id + 1)
    assert_response :not_found
  end
end
