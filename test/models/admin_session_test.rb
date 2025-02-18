require "test_helper"

class AdminSessionTest < ActiveSupport::TestCase
  setup do
    @admin = admins(:one)
    @admin_session = AdminSession.new(admin: @admin,ip_address: "192.168.1.1",user_agent: "test")
  end

  test "有効なAdminSessionが保存できる" do
    assert_difference("AdminSession.count", 1) do
      assert @admin_session.save
    end
  end

  test "adminは必須" do
    @admin_session.admin = nil
    assert_not @admin_session.save, "adminがない場合は無効であるべき"
    assert_includes @admin_session.errors[:admin], "must exist"
  end

  test "ip_addressは任意" do
    @admin_session.ip_address = nil
    assert @admin_session.save
  end

  test "user_agentは任意" do
    @admin_session.user_agent = nil
    assert @admin_session.save
  end

  test "同じadminで複数のセッションを作成できる" do
    @admin_session.save
    another_session = AdminSession.new(admin: @admin, ip_address: "192.168.1.2", user_agent: "Chrome")
    assert another_session.save
  end

  test "セッションを削除するとDBから消える" do
    @admin_session.save
    assert_difference("AdminSession.count", -1) do
      @admin_session.destroy
    end
  end

  test "複数セッションを同時に作成できる" do
    assert_difference("AdminSession.count", 3) do
      3.times do |i|
        AdminSession.create(
          admin: @admin,
          ip_address: "192.168.1.#{i}",
          user_agent: "TestAgent#{i}"
        )
      end
    end
  end

  test "複数セッションを削除すると正しく減少する" do
    sessions = 3.times.map do |i|
      AdminSession.create(
        admin: @admin,
        ip_address: "192.168.1.#{i}",
        user_agent: "TestAgent#{i}"
      )
    end

    assert_difference("AdminSession.count", -3) do
      sessions.each(&:destroy)
    end
  end
end
