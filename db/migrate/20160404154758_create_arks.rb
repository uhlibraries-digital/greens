class CreateArks < ActiveRecord::Migration[5.1]
  def change
    create_table :arks do |t|
      t.string 'identifier', :limit => 50, :null => false
      t.string 'who', :limit => 1000
      t.string 'what', :limit => 1000
      t.string 'when', :limit => 30
      t.string 'where', :limit => 2000
      t.timestamps null: false
    end
    add_index :arks, :identifier, unique: true
  end
end
