class Item < ApplicationRecord
  validates :name, :image, :quantity, :minimum_bets, :online_at,
            :offline_at, :start_at, :status, presence: true
  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }
end
