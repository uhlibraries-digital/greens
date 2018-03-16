class CreateMinterState < ActiveRecord::Migration[5.0]
  def change
    create_table :minter_states do |t|
      t.string :prefix, null: false
      t.string :template, null: false
      t.binary :state
      t.timestamps null: false
    end
    add_index :minter_states, :prefix, unique: true
  end
end
