class Item < ApplicationRecord
  validates :name, :image, :quantity, :minimum_bets, :online_at,
            :offline_at, :start_at, :status, presence: true
  default_scope { where(deleted_at: nil) }
  mount_uploader :image, ImageUploader
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :bets

  enum status: { inactive: 0, active: 1 }

  def destroy
    unless bets.present?
      update(deleted_at: Time.current)
    end
  end

  include AASM

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
      transitions from: :starting, to: :ended, after: :pick_winner, guards: :minimum_bets?
    end

    event :cancel, after: [:return_bet, :return_quantity] do
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
    offline_at > Time.current
  end

  def return_bet
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each {| bet | bet.cancel! }
  end

  def return_quantity
    self.update!(quantity: self.quantity + 1)
  end

  def minimum_bets?
    self.bets.where(batch_count: batch_count, item_id: id).count >= self.minimum_bets
  end

  def pick_winner
    bet_list = self.bets.where(batch_count: batch_count).all
    winner = bet_list.sample
    winner.win!
    bet_list.where.not(id: winner.id).update(state: :lost)
    lucky_winner = Winner.new(item_batch_count: winner.batch_count, user: winner.user, item: winner.item, bet: winner, address: winner.user.addresses.find_by(is_default: true))
    lucky_winner.save!
  end
end
