require "csv"

class ProductImporterService
    def initialize(csv_data)
        @csv_data = csv_data
    end

    def call
    success_count = 0
    error_count = 0
    errors = []
    products_to_insert = []

    CSV.parse(@csv_data, headers: true) do |row|
        brand = Brand.find_by(name: row["brand"])
        if row['name'].blank?
            errors << "商品名がありません"
            error_count += 1
            next
        end
        if brand.nil?
            errors << "#{row['name']} のブランド#{row['brand']}が存在しません"
            error_count += 1
        next
        end

        if row["price"].present? && (row["price"].to_s.match?(/[^0-9.]/) || row["price"].to_f < 0)
            errors << "#{row['name']} の価格が無効です"
            error_count += 1
            next
        end

        production_started_on = nil
        if row["production_started_on"].present?
            begin
                production_started_on = Date.parse(row["production_started_on"])
            rescue ArgumentError
                errors << "#{row['name']} の日付が不正です"
                error_count += 1
                next
            end
        end
        products_to_insert << {
        name: row["name"],
        price: row["price"].present? ? row["price"].to_f : nil,
        body: row["body"].present? ? row["body"] : nil,
        production_started_on: production_started_on,
        brand_id: brand.id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    if products_to_insert.any?
        Product.insert_all(products_to_insert)
        success_count = products_to_insert.size
    end
    { success_count: success_count, error_count: error_count, errors: errors }
    end
end
