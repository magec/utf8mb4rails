class CreateMigrationTest < ActiveRecord::Migration
  def change
    create_table :migration_tests do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
