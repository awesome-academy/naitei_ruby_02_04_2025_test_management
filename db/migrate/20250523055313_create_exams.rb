class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.references :subject, foreign_key: true, null: false
      t.string :name, null: false
      t.datetime :open_at
      t.datetime :close_at
      t.integer :duration_minutes
      t.integer :retries, null: false
      t.integer :pass_ratio, null: false

      t.timestamps
    end
  end
end
