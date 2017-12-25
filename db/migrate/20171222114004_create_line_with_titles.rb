class CreateLineWithTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :line_with_titles do |t|
      t.string :title
      t.string :line
    end
    add_index :line_with_titles, :line
  end
end
