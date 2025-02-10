require "test_helper"

class BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @user = users(:one)
  end

  test "ブランド一覧ページにアクセス可能" do
    get brands_url
    assert_response :success, "ブランド一覧ページにアクセスできません"
  end

  test "未認証でブランドnewページにアクセス不可" do
    get new_brand_url
    assert_redirected_to new_session_url
  end

  test "認証済みでnewページにアクセス可能" do
    log_in_as(@user, "password")
    get new_brand_url
    assert_response :success, "認証済みでブランドnewページにアクセスできません"
  end

  test "未認証でブランドを作成不可" do
    assert_no_difference("Brand.count") do
      post brands_url, params: { name: "Brand Name" }
    end
    assert_redirected_to new_session_url
  end
  
  test "認証済みでブランドを作成可能" do
    log_in_as(@user, "password")
    assert_difference("Brand.count") do
      post brands_url, params: { brand: { name: "Brand Name" } }
    end
    assert_redirected_to brand_url(Brand.last)
  end

  test "ブランドページにアクセス可能" do
    get brand_url(@brand)
    assert_response :success
  end

  test "未認証でブランド編集ページにアクセス不可" do
    get edit_brand_url(@brand)
    assert_redirected_to new_session_url
  end

  test "認証済みでブランド編集ページにアクセス可能" do
    log_in_as(@user, "password")
    get edit_brand_url(@brand)
    assert_response :success
  end

  test "未認証でブランドを更新不可" do
    patch brand_url(@brand), params: { name: "New Brand Name" }
    assert_redirected_to new_session_url
  end

  test "認証済みでブランドを更新可能" do
    log_in_as(@user, "password")
    patch brand_url(@brand), params: { brand: { name: "New Brand Name" } }
    assert_redirected_to brand_url(@brand)
  end

  test "未認証でブランドを削除不可" do
    assert_no_difference("Brand.count") do
      delete brand_url(@brand)
    end
    assert_redirected_to new_session_url
  end
  
  test "認証済みでブランドを削除可能" do
    log_in_as(@user, "password")
    assert_difference("Brand.count", -1) do
      delete brand_url(@brand)
    end
    assert_redirected_to brands_url
  end

  test "ブランド作成時に無効なパラメータが渡された場合のエラー処理" do
    log_in_as(@user, "password")
    assert_no_difference("Brand.count") do
      post brands_url, params: { wrong: { name: "hello"} }
    end
    assert_response :bad_request
  end

  test "ブランド作成時に無効なデータを渡すとブランド更新不可" do
    log_in_as(@user, "password")
    patch brand_url(@brand), params: { brand: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "存在しないブランドにアクセスするとエラーページが表示される" do
    get brand_url(id: "99999")
    assert_response :not_found
  end
end
