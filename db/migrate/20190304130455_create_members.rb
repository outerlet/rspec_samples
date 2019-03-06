class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.string :name_kana
      t.integer :sex
      t.date :birthday
      t.integer :prefecture_id
      t.text :comment

      t.timestamps
    end

    add_index :members, %i(name sex birthday), unique: true
  end
end
