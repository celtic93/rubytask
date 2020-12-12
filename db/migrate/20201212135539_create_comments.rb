class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.belongs_to :user
      t.belongs_to :task

      t.timestamps
    end
  end
end
