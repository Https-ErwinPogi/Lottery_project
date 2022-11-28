class User < ApplicationRecord
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: {client: '0', admin: '1'}
end