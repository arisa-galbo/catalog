require "test_helper"

class BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
  end

  test "ブランド一覧ページにアクセス可能" do
    get brands_url
    assert_response :success, "ブランド一覧ページにアクセスできません"
  end

  test "ブランドページにアクセス可能" do
    get brand_url(@brand)
    assert_response :success
  end

  test "存在しないブランドにアクセスするとエラーページが表示される" do
    get brand_url(id: "99999")
    assert_response :not_found
  end
end
