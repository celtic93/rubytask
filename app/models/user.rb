class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i(admin worker client)

  validates :login, :fullname, :birthday, :address, :city,
            :state, :country, :zip, presence: true
end
