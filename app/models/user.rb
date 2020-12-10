class User < ApplicationRecord
  has_many :tasks
  has_many :work_tasks, class_name: 'Task'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i(admin worker client)

  validates :login, :fullname, :birthday, :address, :city,
            :state, :country, :zip, :role, presence: true
end
