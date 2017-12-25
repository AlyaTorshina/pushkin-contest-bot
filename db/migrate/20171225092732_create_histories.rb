class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.string :question
      t.integer :identifier
      t.integer :level
      t.datetime :time
      t.string :answer
    end
  end
end
