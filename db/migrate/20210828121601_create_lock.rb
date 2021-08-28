class CreateLock < ActiveRecord::Migration[5.1]
  def change
    create_table :locks do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :locks, :name, unique: true
  end
end
