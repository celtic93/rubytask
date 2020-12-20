class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :tasks
  has_many :works, class_name: 'Task', foreign_key: :worker_id
  has_many :task_requests
  has_many :work_requests, class_name: 'TaskRequest', foreign_key: :worker_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i(admin worker client)

  validates :login, :fullname, :birthday, :address, :city,
            :state, :country, :zip, :role, presence: true

  geocoded_by :full_address
  after_validation :geocode, if: :full_address_changed?

  def author?(resource)
    id == resource.user_id
  end

  private

  def full_address
    [address, city, state, country, zip].compact.join(', ')
  end

  def full_address_changed?
    address_changed? || city_changed? || state_changed? || country_changed? || zip_changed?
  end
end
