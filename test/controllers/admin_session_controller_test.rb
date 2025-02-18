require "test_helper"

class AdminSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
  end

  test "管理者ログインページにアクセス可能" do
    get new_admin_session_path
    assert_response :success
  end

  test "正しい情報で管理者ログイン可能" do
    log_in_as_admin(@admin, "password")
    assert_redirected_to root_path
  end

  test "誤ったパスワードで管理者ログイン不可" do
    log_in_as_admin(@admin, "wrongpassword")
    assert_redirected_to new_admin_session_path
    assert_equal "Invalid email or password.", flash[:alert]
  end

  test "誤ったメールアドレスで管理者ログイン不可" do
    post admin_session_path, params: { email_address: @admin.email_address + "x", password: "password" }
    assert_redirected_to new_admin_session_path
    assert_equal "Invalid email or password.", flash[:alert]
  end

  test "管理者ログアウト可能" do
    log_in_as_admin(@admin, "password")
    log_out_admin
    assert_redirected_to new_admin_session_path
  end
end
