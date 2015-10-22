class CreateNomads < ActiveRecord::Migration
  def change
    create_table :spree_nomads do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :email
      t.string :contry
      t.string :destination
      t.text :reason
      t.text :expect
      t.text :skills

      t.timestamps
    end
  end
end
