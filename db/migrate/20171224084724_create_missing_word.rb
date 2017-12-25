class CreateMissingWord < ActiveRecord::Migration[5.1]
  def change
    create_table :missing_words do |t|
      t.string :question
      t.string :answer
    end
    add_index :missing_words, :question
  end
end
