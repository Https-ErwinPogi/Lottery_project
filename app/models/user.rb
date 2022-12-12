class User < ApplicationRecord
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }
  has_many :addresses
  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  has_many :bets
  validates :coins, numericality: { greater_than_or_equal_to: 0 }

  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  enum role: { client: 0, admin: 1 }
end