class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :body
      t.date :production_started_on
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
