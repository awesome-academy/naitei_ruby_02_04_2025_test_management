class CreateEnrolledSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :enrolled_subjects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
    add_index :enrolled_subjects, [:user_id, :subject_id], unique: true
  end
end
