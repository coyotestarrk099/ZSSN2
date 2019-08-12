class CreateSurvivors < ActiveRecord::Migration[5.2]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.float :latitude
      t.float :longitude
      t.integer :infected
      t.integer :water_amount
      t.integer :ammunition_amount
      t.integer :medication_amount
      t.integer :food_amount

      t.timestamps
    end
  end
end
