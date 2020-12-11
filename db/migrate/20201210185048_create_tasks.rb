class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.text :body, null: false
      t.belongs_to :user
      t.belongs_to :worker, class_name: 'User', optional: true

      t.timestamps
    end
  end
end
