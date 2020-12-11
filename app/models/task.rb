class Task < ApplicationRecord
  belongs_to :user
  belongs_to :worker, class_name: 'User', optional: true

  validates :body, presence: true
end
