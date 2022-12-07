class Category < ApplicationRecord
  validates :name, presence: true
  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships

  def destroy
    unless items.present?
      update(deleted_at: Time.current)
    end
  end
end
