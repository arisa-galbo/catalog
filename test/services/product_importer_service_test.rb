require "test_helper"
require "csv"

class ProductImporterServiceTest < ActiveSupport::TestCase
    setup do
        @valid_csv_data = <<~CSV
          name,price,body,production_started_on,brand
          Test1,2000,This is a test,2025-01-01,Test Brand 1
          Test2,,test test test,2025/01/01,Test Brand 2
          Test3,,,,Test Brand 1
        CSV
    
        @invalid_csv_data = <<~CSV
          name,price,body,production_started_on,brand
          ,10.0,No name product,2025-01-01,Test Brand 1
          Test2,100.0,this is a test,2025-01-01,Test Brand 1
          Test3,200.0,Unknown brand,2025-01-01,Nonexistent Brand
          Test4,-100.0,this is a test,2025-01-01,Test Brand 1
          Test5,100,invalid date,2025/2/30,Test Brand 1
          Test6,hello,invalid price, ,Test Brand 2
        CSV
    
        @missing_column_csv_data = <<~CSV
          name,price,body
          Test Product,100.0,hello
        CSV
    end
    
    test "CSV から有効な商品を登録できる" do
        assert_difference("Product.count", 3, "有効な商品が3件登録されるべき") do
            service = ProductImporterService.new(@valid_csv_data)
            result = service.call
            assert_equal [], result[:errors], "無効な商品が0エラーとなるべき"
            assert_equal 3, result[:success_count], "有効な商品が3件登録されるべき"
        end
    end

    test "不正なデータの商品は登録されない" do
        assert_difference("Product.count", 1, "登録済みブランドで商品名をもつ商品だけが登録されるべき") do
            service = ProductImporterService.new(@invalid_csv_data)
            result = service.call
            assert_equal 1, result[:success_count], "有効な商品が1件登録されるべき"
            expected_errors = [
                "Test3 のブランドNonexistent Brandが存在しません",
                "商品名がありません",
                "Test4 の価格が無効です",
                "Test5 の日付が不正です",
                "Test6 の価格が無効です",
            ]
            assert_equal expected_errors.sort, result[:errors].sort, "エラーメッセージが適切であるべき"
            assert_equal 5, result[:error_count], "無効な商品が5エラーとなるべき"
        end
    end

    test "CSVのカラムが足りない場合はエラーになる" do
        assert_no_difference("Product.count", "カラム不足の場合は商品が登録されるべきではない") do
            service = ProductImporterService.new(@missing_column_csv_data)
            result = service.call
            assert_equal 0, result[:success_count], "カラムが足りない場合は登録されないべき"
            assert result[:errors].any?, "カラム不適のエラーが発生していない"
        end
    end    
end
