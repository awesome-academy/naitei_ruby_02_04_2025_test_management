class RemoveOpenAtAndCloseAtFromExams < ActiveRecord::Migration[7.0]
  def change
    remove_column :exams, :open_at, :datetime
    remove_column :exams, :close_at, :datetime
  end
end
