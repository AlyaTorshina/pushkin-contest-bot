class CreateTestHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :test_histories do |t|
      t.string :question
      t.string :number
      t.integer :level

      t.timestamps
    end
  end
end
