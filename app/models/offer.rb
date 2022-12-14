class Offer < ApplicationRecord
  validates :image, :status, :genre, :coin, :amount, :name, presence: true
  enum status: [:active, :inactive]
  enum genre: [:one_time, :monthly, :weekly, :daily, :regular]

  mount_uploader :image, ImageUploader
end
