class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :priority
      t.date :due_date

      t.timestamps
    end
  end
end
