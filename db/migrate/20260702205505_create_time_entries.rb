class CreateTimeEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :time_entries do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.decimal :hourly_rate_snapshot

      t.timestamps
    end
  end
end
