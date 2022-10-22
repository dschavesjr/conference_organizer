class CreatePalestras < ActiveRecord::Migration[7.0]
  def change
    create_table :palestras do |t|
      t.string :nome
      t.integer :tempo

      t.timestamps
    end
  end
end
