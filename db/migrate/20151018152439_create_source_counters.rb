class CreateSourceCounters < ActiveRecord::Migration
  def change
    create_table :source_counters do |t|
      t.string :source
      t.integer :count

      t.timestamps
    end
  end
end
