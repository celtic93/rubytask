class CreateTaskRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :task_requests do |t|
      t.belongs_to :user
      t.belongs_to :task
      t.belongs_to :worker, class_name: 'User'
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :task_requests, [:user_id, :task_id, :worker_id], unique: true
  end
end
