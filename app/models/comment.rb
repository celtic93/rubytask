class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_one_attached :image

  validates :body, presence: true
  validates :image, size: { less_than: 1.megabyte , message: 'is not given between size' },
                    content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
