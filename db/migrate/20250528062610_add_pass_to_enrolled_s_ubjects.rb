class AddPassToEnrolledSUbjects < ActiveRecord::Migration[7.0]
  def change
    add_column :enrolled_subjects, :is_pass, :boolean, default: false, null: false
  end
end
