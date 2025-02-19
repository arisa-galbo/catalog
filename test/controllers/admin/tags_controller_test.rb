require "test_helper"

class Admin::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:one)
    @product = products(:one)
    @user = users(:one)
    @tag = tags(:one)
    @admin = admins(:one)
  end

  test "管理者が管理者タグ一覧ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_tags_url
    assert_response :success
  end
  
  test "非管理者が管理者タグ一覧ページにアクセス不可" do
    get admin_tags_url
    assert_redirected_to new_admin_session_url
    log_in_as(@user, "password")
    get admin_tags_url
    assert_redirected_to new_admin_session_url
  end
  
  test "管理者が管理者タグ詳細ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get admin_tag_url(@tag)
    assert_response :success
  end

  test "未認証ユーザーはタグ作成ページにアクセス不可" do
    get new_admin_tag_url
    assert_redirected_to new_admin_session_url
    log_in_as(@user, "password")
    get new_admin_tag_url
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーはタグ作成ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get new_admin_tag_url
    assert_response :success
  end

  test "未認証ユーザーはタグを作成不可" do
    assert_no_difference("Tag.count") do
      post admin_tags_url, params: { tag: { name: "New Tag" } }
    end
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーはタグを作成可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Tag.count", 1, "タグの作成に失敗したか、作成数が期待と異なる") do
      post admin_tags_url, params: { tag: { name: "New Tag" } }
    end
    assert_redirected_to admin_tag_path(Tag.last)
  end

  test "未認証ユーザーはタグ編集ページにアクセス不可" do
    get edit_admin_tag_url(@tag)
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーはタグ編集ページにアクセス可能" do
    log_in_as_admin(@admin, "password")
    get edit_admin_tag_url(@tag)
    assert_response :success
  end

  test "未認証ユーザーはタグを更新不可" do
    patch admin_tag_url(@tag), params: { tag: { name: "Updated Tag Name" } }
    assert_redirected_to new_admin_session_url
    @tag.reload
    assert_equal "Test Tag 1", @tag.name, "未認証ユーザーがタグを更新できている"
  end

  test "認証ユーザーはタグを更新可能" do
    log_in_as_admin(@admin, "password")
    patch admin_tag_url(@tag), params: { tag: { name: "Updated Tag Name" } }
    assert_redirected_to admin_tag_path(@tag)
    @tag.reload
    assert_equal "Updated Tag Name", @tag.name, "認証ユーザーがタグを更新できていない"
  end

  test "未認証ユーザーはタグを削除不可" do
    assert_no_difference("Tag.count") do
      delete admin_tag_url(@tag)
    end
    assert_redirected_to new_admin_session_url
  end

  test "認証ユーザーはタグを削除可能" do
    log_in_as_admin(@admin, "password")
    assert_difference("Tag.count", -1) do
      delete admin_tag_url(@tag)
    end
    assert_redirected_to admin_tags_url
  end

  test "タグ作成時に無効なデータを渡すと更新不可" do
    log_in_as_admin(@admin, "password")
    post admin_tags_url, params: { tag: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "タグ更新時に無効なデータを渡すと更新不可" do
    log_in_as_admin(@admin, "password")
    patch admin_tag_url(@tag), params: { tag: { name: "" } }
    assert_response :unprocessable_entity
  end
end
