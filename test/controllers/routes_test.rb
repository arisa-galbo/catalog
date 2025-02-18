require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
    test "ルートページへのルーティング" do
        assert_routing "/", controller: "home", action: "index"
    end

    test "ブランドのルーティング(index, show, new, create, edit, update, destroy)" do
        assert_routing "/brands", controller: "brands", action: "index"
        assert_routing "/brands/1", controller: "brands", action: "show", id: "1"
        assert_routing "/brands/new", controller: "brands", action: "new"
        assert_routing({ method: :post, path: "/brands" }, { controller: "brands", action: "create" })
        assert_routing "/brands/1/edit", controller: "brands", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/brands/1" }, { controller: "brands", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/brands/1" }, { controller: "brands", action: "destroy", id: "1" })
    end

    test "商品のnewとcreateはブランドにネストされたルーティング" do
        assert_routing "/brands/1/products/new", controller: "products", action: "new", brand_id: "1"
        assert_routing({ method: :post, path: "/brands/1/products" }, { controller: "products", action: "create", brand_id: "1" })
    end

    test "商品の登録以外のルーティング(index, show, edit, update, destroy,upload)" do
        assert_routing "/products", controller: "products", action: "index"
        assert_routing "/products/upload", controller: "products", action: "upload"
        assert_routing({ method: :post, path: "/products/process_upload" }, { controller: "products", action: "process_upload" })
        assert_routing "/products/1", controller: "products", action: "show", id: "1"
        assert_routing "/products/1/edit", controller: "products", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/products/1" }, { controller: "products", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/products/1" }, { controller: "products", action: "destroy", id: "1" })
    end

    test "商品登録タグは商品にネストされたルーティング(new, create, edit, update, destroy)" do
        assert_routing "/products/1/product_tags/new", controller: "product_tags", action: "new", product_id: "1"
        assert_routing({ method: :post, path: "/products/1/product_tags" }, { controller: "product_tags", action: "create", product_id: "1" })
        assert_routing "/products/1/product_tags/1/edit", controller: "product_tags", action: "edit", product_id: "1", id: "1"
        assert_routing({ method: :patch, path: "/products/1/product_tags/1" }, { controller: "product_tags", action: "update", product_id: "1", id: "1" })
        assert_routing({ method: :delete, path: "/products/1/product_tags/1" }, { controller: "product_tags", action: "destroy", product_id: "1", id: "1" })
    end

    test "タグのルーティング(index, show, new, create, edit, update, destroy)" do
        assert_routing "/tags", controller: "tags", action: "index"
        assert_routing "/tags/1", controller: "tags", action: "show", id: "1"
        assert_routing "/tags/new", controller: "tags", action: "new"
        assert_routing({ method: :post, path: "/tags" }, { controller: "tags", action: "create" })
        assert_routing "/tags/1/edit", controller: "tags", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/tags/1" }, { controller: "tags", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/tags/1" }, { controller: "tags", action: "destroy", id: "1" })
    end

    test "adminセッションのルーティング(new, create, destroy)" do
        assert_routing "/admin_session/new", controller: "admin_sessions", action: "new"
        assert_routing({ method: :post, path: "/admin_session" }, { controller: "admin_sessions", action: "create" })
        assert_routing({ method: :delete, path: "/admin_session" }, { controller: "admin_sessions", action: "destroy" })
    end

    test "userセッションのルーティング(new, create, destroy)" do
        assert_routing "/session/new", controller: "sessions", action: "new"
        assert_routing({ method: :post, path: "/session" }, { controller: "sessions", action: "create" })
        assert_routing({ method: :delete, path: "/session" }, { controller: "sessions", action: "destroy" })
    end
end

