class Offer < ApplicationRecord
  validates :image, :status, :genre, :coin, :amount, :name, presence: true
  enum status: { inactive: 0, active: 1 }
  enum genre: { regular: 0, daily: 1, weekly: 2, monthly: 3, one_time: 4 }
  has_many :orders

  mount_uploader :image, ImageUploader
end
