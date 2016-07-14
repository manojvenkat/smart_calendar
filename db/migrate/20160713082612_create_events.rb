class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :all_day, default: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
