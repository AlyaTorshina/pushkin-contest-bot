class CreateSortedLines < ActiveRecord::Migration[5.1]
  def change
    create_table :sorted_lines do |t|
      t.string :sorted_line
      t.string :line
    end
    add_index :sorted_lines, :sorted_line
  end
end
