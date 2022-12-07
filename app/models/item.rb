class Item < ApplicationRecord
  include AASM
  validates :name, :image, :quantity, :minimum_bets, :online_at,
            :offline_at, :start_at, :status, presence: true
  default_scope { where(deleted_at: nil) }
  mount_uploader :image, ImageUploader

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  enum status: { inactive: 0, active: 1 }

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :cancelled, :ended], to: :starting, after: :total_batch, guards: [:quantity_not_negative?, :less_than_present_day?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end

  end

  def total_batch
    batch_count = self.batch_count + 1
    quantity = self.quantity - 1
    update(batch_count: batch_count, quantity: quantity)
  end

  def quantity_not_negative?
    quantity >= 0
  end

  def less_than_present_day?
    offline_at > Time.now
  end

  def active?
    status == "active"
  end
end
