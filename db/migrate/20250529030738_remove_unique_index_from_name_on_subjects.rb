class RemoveUniqueIndexFromNameOnSubjects < ActiveRecord::Migration[7.0]
  def change
    remove_index :subjects, :name, name: :index_subjects_on_name, unique: true
    add_index :subjects, :name
  end
end
