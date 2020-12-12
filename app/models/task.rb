class Task < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :worker, class_name: 'User', optional: true

  validates :body, presence: true
end
