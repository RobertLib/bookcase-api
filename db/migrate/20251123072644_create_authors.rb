class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :biography
      t.date :born_at

      t.timestamps
    end
  end
end
