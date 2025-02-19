require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @product = products(:one)
    @user = users(:one)
    @tag = tags(:one)
  end

  test "タグ一覧ページにアクセス可能" do
    get tags_url
    assert_response :success
  end
  
  test "タグ詳細ページにアクセス可能" do
    get tag_url(@tag)
    assert_response :success
  end

  test "存在しないタグにアクセスするとエラーページが表示される" do
    get tag_url(id: "99999")
    assert_response :not_found
  end
end
