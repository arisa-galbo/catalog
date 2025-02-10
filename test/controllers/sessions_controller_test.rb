require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "ログインページにアクセス可能" do
    get new_session_path
    assert_response :success
  end

  test "正しい情報でログイン可能" do
    log_in_as(@user, "password")
    assert_redirected_to root_path
  end

  test "誤ったパスワードでログイン不可" do
    log_in_as(@user, "wrongpassword")
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "誤ったメールアドレスでログイン不可" do
    post session_path, params: { email_address: @user.email_address + "x", password: "password" }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "ログアウト可能" do
    log_in_as(@user, "password")
    log_out
    assert_redirected_to new_session_path
  end
end
