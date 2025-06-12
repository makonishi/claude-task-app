class ChangePriorityToStringInTasks < ActiveRecord::Migration[7.2]
  def change
    change_column :tasks, :priority, :string
  end
end
