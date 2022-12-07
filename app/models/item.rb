class Item < ApplicationRecord
  validates :name, :image, :quantity, :minimum_bets, :online_at,
            :offline_at, :start_at, :status, presence: true
  default_scope { where(deleted_at: nil) }
  mount_uploader :image, ImageUploader

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  enum status: { inactive: 0, active: 1 }

  def destroy
    update(deleted_at: Time.current)
  end
end
