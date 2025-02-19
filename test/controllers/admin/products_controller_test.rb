require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @product = products(:one)
    @user = users(:one)
    @admin = admins(:one)
    @valid_csv = fixture_file_upload("valid_products.csv", "text/csv")
    @invalid_csv = fixture_file_upload("invalid_products.csv", "text/csv")
    @empty_csv = fixture_file_upload("empty.csv", "text/csv")
    @missing_column_csv = fixture_file_upload("missing_column.csv", "text/csv")
  end

  test "管理者が管理者商品一覧ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_products_url
    assert_response :success
  end

  test "非管理者が管理者商品一覧ページにアクセス不可" do
    get admin_products_url
    assert_redirected_to new_admin_session_url
    log_in_as(@user, "password")
    get admin_products_url
    assert_redirected_to new_admin_session_url
  end

  test "管理者が管理者商品詳細ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_product_url(@product)
    assert_response :success
  end

  test "非管理者が管理者商品詳細ページにアクセス不可" do
    get admin_product_url(@product)
    assert_redirected_to new_admin_session_url, "未認証者が管理者商品詳細ページにアクセスできます"
    log_in_as(@user, "password")
    get admin_product_url(@product)
    assert_redirected_to new_admin_session_url, "認証ユーザが管理者商品詳細ページにアクセスできます"
  end

  test "未認証ユーザーは商品作成ページにアクセス不可" do
    get new_admin_brand_product_url(@brand)
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーは商品作成ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get new_admin_brand_product_url(@brand)
    assert_response :success
  end

  test "未認証ユーザーは商品を作成不可" do
    assert_no_difference("Product.count") do
      post admin_brand_products_url(@brand), params: { product: { name: "New Product", price: 1000, body: "説明", production_started_on: Date.today } }
    end
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーは商品を作成可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Product.count", 1) do
      post admin_brand_products_url(@brand), params: { product: { name: "New Product", price: 1000, body: "説明", production_started_on: Date.today ,image_url: "https://example.com/image.jpg" } }
    end
    assert_redirected_to admin_product_url(Product.last)
  end

  test "未認証ユーザーは商品編集ページにアクセス不可" do
    get edit_admin_product_url(@product)
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーは商品編集ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get edit_admin_product_url(@product)
    assert_response :success
  end

  test "未認証ユーザーは商品を更新不可" do
    patch admin_product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to new_admin_session_url
    @product.reload
    assert_equal "Test Product 1", @product.name, "未認証ユーザーが商品を更新できている"
  end

  test "認証ユーザーは商品を更新可能" do
    log_in_as_admin(@admin, "password")
    patch admin_product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to admin_product_url(@product)
    @product.reload
    assert_equal "Updated Name", @product.name, "商品が更新されていません"
  end

  test "未認証ユーザーは商品を削除不可" do
    assert_no_difference("Product.count","未認証ユーザが商品を削除できた") do
      delete admin_product_url(@product)
    end
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーは商品を削除可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Product.count", -1, "商品の削除された数が不正") do
      delete admin_product_url(@product)
    end
    assert_redirected_to admin_products_url
  end

  test "商品作成時に無効なデータを渡すと更新不可" do
    log_in_as_admin(@admin, "password")
    post admin_brand_products_url(@brand), params: { product: { name: "", price: 1000, body: "説明", production_started_on: Date.today } }
    assert_response :unprocessable_entity
  end

  test "商品更新時に無効なデータを渡すと更新不可" do
    log_in_as_admin(@admin, "password")
    patch admin_product_url(@product), params: { product: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "存在しない商品にアクセスするとエラーページが表示される" do
    log_in_as_admin(@admin, "password")
    get admin_product_url(Product.last.id + 1)
    assert_response :not_found
  end

  test "認証ユーザはアップロードページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get upload_admin_products_url
    assert_response :success
  end

  test "未認証ユーザはアップロードページにアクセス不可" do
    get upload_admin_products_url
    assert_redirected_to new_admin_session_url
  end

  test "有効なCSVをアップロードすると商品が登録される" do
    log_in_as_admin(@admin, "password")
    assert_difference("Product.count", 4) do
      post process_upload_admin_products_url, params: { file: @valid_csv }
    end
    assert_redirected_to admin_products_url
    assert_equal "商品が 4 件登録されました", flash[:notice]
  end

  test "無効な値の入ったCSVをアップロードするとエラーが発生する" do
    log_in_as_admin(@admin, "password")
    assert_no_difference("Product.count") do
      post process_upload_admin_products_url, params: { file: @invalid_csv }
    end
    assert_response :unprocessable_entity
    assert_match "エラー:", flash[:alert]
  end

  test "空のCSVをアップロードするとエラーが発生する" do
    log_in_as_admin(@admin, "password")
    assert_no_difference("Product.count") do
      post process_upload_admin_products_url, params: { file: @empty_csv}
    end
    assert_response :unprocessable_entity
    assert_match "エラー:", flash[:alert]
  end

  test "カラムの不足したCSVをアップロードするとエラーが発生する" do
    log_in_as_admin(@admin, "password")
    assert_no_difference("Product.count") do
      post process_upload_admin_products_url, params: { file: @missing_column_csv }
    end
    assert_response :unprocessable_entity
    assert_match "エラー:", flash[:alert]
  end

  test "CSVがアップロードされなかった場合エラーになる" do
    log_in_as_admin(@admin, "password")
    post process_upload_admin_products_url, params: { file: nil }
    assert_redirected_to upload_admin_products_url
    assert_equal "CSVファイルを選択してください", flash[:alert]
  end

end