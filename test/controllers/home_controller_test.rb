require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "トップページにアクセスできる" do
    get "/"
    assert_response :success, "トップページにアクセスできません"
  end
end
