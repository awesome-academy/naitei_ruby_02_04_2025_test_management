class CreateExamResults < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_results do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score, default: 0
      t.string :status, null: false, default: "pending"
      t.integer :attempt, default: 0

      t.timestamps
    end
  end
end
