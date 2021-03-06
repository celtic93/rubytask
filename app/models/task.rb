class Task < ApplicationRecord
  include PgSearch::Model

  has_many :comments, dependent: :destroy
  has_many :task_requests, dependent: :destroy
  has_many :work_requestors, through: :task_requests, source: :worker
  belongs_to :user
  belongs_to :worker, class_name: 'User', optional: true

  has_one_attached :image

  validates :body, presence: true
  validates :image, size: { less_than: 1.megabyte , message: 'is not given between size' },
                    content_type: ['image/png', 'image/jpg', 'image/jpeg']

  pg_search_scope :search_tasks, against: :body,
                                 associated_against: { user: [:address, :fullname, :login] }

  def requested_by?(user)
    work_requestor_ids.include?(user.id)
  end
end
