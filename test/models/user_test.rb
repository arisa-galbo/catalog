require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "正しい情報で認証可能" do
    assert User.authenticate_by(email_address: @user.email_address, password: "password"), "正しい情報で認証が通りません"
  end

  test "間違ったパスワードで認証不可" do
    assert_nil User.authenticate_by(email_address: @user.email_address, password: "wrongpassword"), "間違ったパスワードで認証が通ります"
  end

  test "誤ったメールアドレスで認証不可" do
    assert_nil User.authenticate_by(email_address: "wrong@example.com", password: "password"), "誤ったメールアドレスで認証が通ります"
  end
end
