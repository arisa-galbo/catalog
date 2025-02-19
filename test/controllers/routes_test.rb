require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
    test "ルートページへのルーティング" do
        assert_routing "/", controller: "home", action: "index"
    end

    test "ブランドの公開ルーティング(index, show)" do
        assert_routing "/brands", controller: "brands", action: "index"
        assert_routing "/brands/1", controller: "brands", action: "show", id: "1"
    end

    test "管理者用のブランドのルーティング(index, show, new, create, edit, update, destroy)" do
        assert_routing "/admin/brands", controller: "admin/brands", action: "index"
        assert_routing "/admin/brands/1", controller: "admin/brands", action: "show", id: "1"
        assert_routing "/admin/brands/new", controller: "admin/brands", action: "new"
        assert_routing({ method: :post, path: "/admin/brands" }, { controller: "admin/brands", action: "create" })
        assert_routing "/admin/brands/1/edit", controller: "admin/brands", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/admin/brands/1" }, { controller: "admin/brands", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/admin/brands/1" }, { controller: "admin/brands", action: "destroy", id: "1" })
    end

    test "商品のnewとcreateはブランドにネストされたルーティング" do
        assert_routing "/admin/brands/1/products/new", controller: "admin/products", action: "new", brand_id: "1"
        assert_routing({ method: :post, path: "/admin/brands/1/products" }, { controller: "admin/products", action: "create", brand_id: "1" })
    end

    test "商品の登録以外の管理者用ルーティング(index, show, edit, update, destroy,upload)" do
        assert_routing "/admin/products", controller: "admin/products", action: "index"
        assert_routing "/admin/products/upload", controller: "admin/products", action: "upload"
        assert_routing({ method: :post, path: "/admin/products/process_upload" }, { controller: "admin/products", action: "process_upload" })
        assert_routing "/admin/products/1", controller: "admin/products", action: "show", id: "1"
        assert_routing "/admin/products/1/edit", controller: "admin/products", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/admin/products/1" }, { controller: "admin/products", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/admin/products/1" }, { controller: "admin/products", action: "destroy", id: "1" })
    end

    test "商品の公開ルーティング(index, show)" do
        assert_routing "/products", controller: "products", action: "index"
        assert_routing "/products/1", controller: "products", action: "show", id: "1"
    end

    test "商品登録タグは商品にネストされたルーティング(new, create, edit, update, destroy)" do
        assert_routing "/admin/products/1/product_tags/new", controller: "admin/product_tags", action: "new", product_id: "1"
        assert_routing({ method: :post, path: "/admin/products/1/product_tags" }, { controller: "admin/product_tags", action: "create", product_id: "1" })
        assert_routing "/admin/products/1/product_tags/1/edit", controller: "admin/product_tags", action: "edit", product_id: "1", id: "1"
        assert_routing({ method: :patch, path: "/admin/products/1/product_tags/1" }, { controller: "admin/product_tags", action: "update", product_id: "1", id: "1" })
        assert_routing({ method: :delete, path: "/admin/products/1/product_tags/1" }, { controller: "admin/product_tags", action: "destroy", product_id: "1", id: "1" })
    end

    test "管理者用タグのルーティング(index, show, new, create, edit, update, destroy)" do
        assert_routing "/admin/tags", controller: "admin/tags", action: "index"
        assert_routing "/admin/tags/1", controller: "admin/tags", action: "show", id: "1"
        assert_routing "/admin/tags/new", controller: "admin/tags", action: "new"
        assert_routing({ method: :post, path: "/admin/tags" }, { controller: "admin/tags", action: "create" })
        assert_routing "/admin/tags/1/edit", controller: "admin/tags", action: "edit", id: "1"
        assert_routing({ method: :patch, path: "/admin/tags/1" }, { controller: "admin/tags", action: "update", id: "1" })
        assert_routing({ method: :delete, path: "/admin/tags/1" }, { controller: "admin/tags", action: "destroy", id: "1" })
    end

    test "公開用タグのルーティング(index, show)" do
        assert_routing "/tags", controller: "tags", action: "index"
        assert_routing "/tags/1", controller: "tags", action: "show", id: "1"
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

