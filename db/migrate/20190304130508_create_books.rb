class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :title_kana
      t.string :author
      t.integer :format
      t.integer :price
      t.string :publisher
      t.date :published
      t.text :summary

      t.timestamps
    end
  end
end
