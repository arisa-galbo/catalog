require "test_helper"

class Admin::BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @user = users(:one)
    @admin = admins(:one)
  end

  test "管理者は管理者ブランド一覧ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_brands_url
    assert_response :success, "ブランド一覧ページにアクセスできません"
  end

  test "非管理者は管理者ブランド一覧ページにアクセス不可" do
    get admin_brands_url
    assert_redirected_to new_admin_session_url,"未認証者が管理者ブランド一覧ページにアクセスできます"
    log_in_as(@user, "password")
    get admin_brands_url
    assert_redirected_to new_admin_session_url,"認証ユーザが管理者ブランド一覧ページにアクセスできます"
  end

  test "未認証でブランドnewページにアクセス不可" do
    get new_admin_brand_url
    assert_redirected_to new_admin_session_url, "未認証者がブランドnewページにアクセスできます"
    log_in_as(@user, "password")
    get new_admin_brand_url
    assert_redirected_to new_admin_session_url,"認証ユーザがブランドnewページにアクセスできます"
  end

  test "認証済みでnewページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get new_admin_brand_url
    assert_response :success, "認証済みで管理者ブランドnewページにアクセスできません"
  end

  test "未認証でブランドを作成不可" do
    assert_no_difference("Brand.count") do
      post admin_brands_url, params: { name: "Brand Name" }
    end
    assert_redirected_to new_admin_session_url,"未認証者がブランドを作成できます"
  end
  
  test "認証済みでブランドを作成可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Brand.count") do
      post admin_brands_url, params: { brand: { name: "Brand Name" } }
    end
    assert_redirected_to admin_brand_url(Brand.last)
  end

  test "管理者は管理者ブランドページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_brand_url(@brand)
    assert_response :success
  end

  test "非管理者は管理者ブランドページにアクセス不可" do
    get admin_brand_url(@brand)
    assert_redirected_to new_admin_session_url
    log_in_as(@user, "password")
    get admin_brand_url(@brand)
    assert_redirected_to new_admin_session_url
  end

  test "未認証でブランド編集ページにアクセス不可" do
    get edit_admin_brand_url(@brand)
    assert_redirected_to new_admin_session_url
  end

  test "認証済みでブランド編集ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get edit_admin_brand_url(@brand)
    assert_response :success
  end

  test "未認証でブランドを更新不可" do
    patch admin_brand_url(@brand), params: { name: "New Brand Name" }
    assert_redirected_to new_admin_session_url
  end

  test "認証済みでブランドを更新可能" do
    log_in_as_admin(@admin, "password")
    patch admin_brand_url(@brand), params: { brand: { name: "New Brand Name" } }
    assert_redirected_to admin_brand_url(@brand)
  end

  test "未認証でブランドを削除不可" do
    assert_no_difference("Brand.count") do
      delete admin_brand_url(@brand)
    end
    assert_redirected_to new_admin_session_url
  end
  
  test "認証済みでブランドを削除可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Brand.count", -1) do
      delete admin_brand_url(@brand)
    end
    assert_redirected_to admin_brands_url
  end

  test "ブランド作成時に無効なパラメータが渡された場合のエラー処理" do
    log_in_as_admin(@admin, "password")
    assert_no_difference("Brand.count") do
      post admin_brands_url, params: { wrong: { name: "hello"} }
    end
    assert_response :bad_request
  end

  test "ブランド作成時に無効なデータを渡すとブランド更新不可" do
    log_in_as_admin(@admin, "password")
    patch admin_brand_url(@brand), params: { brand: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "存在しないブランドにアクセスするとエラーページが表示される" do
    log_in_as_admin(@admin, "password")
    get admin_brand_url(id: "99999")
    assert_response :not_found
  end
end
