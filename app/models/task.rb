class Task < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :worker, class_name: 'User', optional: true

  has_one_attached :image

  validates :body, presence: true
  validates :image, size: { less_than: 1.megabyte , message: 'is not given between size' },
                    content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
