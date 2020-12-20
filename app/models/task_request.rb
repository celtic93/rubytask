class TaskRequest < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :worker, class_name: 'User'

  enum status: %i(pending rejected accepted)

  validates :user, uniqueness: { scope: [:task, :worker] }
end
