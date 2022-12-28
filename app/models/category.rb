class Category < ApplicationRecord
  validates :name, :sort, presence: true
  validates_uniqueness_of :sort
  default_scope { where(deleted_at: nil) }
  default_scope { order(:sort) }

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships

  def destroy
    unless items.present?
      update(deleted_at: Time.current)
    end
  end
end
