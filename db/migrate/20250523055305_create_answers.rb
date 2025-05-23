class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :is_correct, null: false, default: false

      t.timestamps
    end
  end
end
