class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :region, default: "eu"
      t.string :realm
      t.integer :gender
      t.string :thumbnail
      t.string :calcClass
      t.integer :charClass
      t.integer :race
      t.integer :level
      t.integer :achievementPoints
      t.string :items
      t.string :stats
      t.string :hunterPets
      t.string :professions
      t.string :talents

      t.timestamps null: false
    end
    add_index :characters, [:name, :realm, :region], :unique => true
  end
end
