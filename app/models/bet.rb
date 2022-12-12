class Bet < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :item
  after_validation :has_enough_coins?, :minimum_bets?
  after_create :generate_serial_number, :deduct_coins_after_bet


  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :refund_coins
    end
  end

  def generate_serial_number
    number_count = Bet.where(batch_count: item.batch_count, item_id: item.id).count.to_s.rjust(4, '0')
    self.update!(serial_number: "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}")
  end

  def deduct_coins_after_bet
    self.user.update!(coins: self.user.coins - self.coins)
  end

  def refund_coins
    self.user.update!(coins: self.user.coins + self.coins)
  end

  def has_enough_coins?
    if self.user.coins <= 0
      errors.add(:base, "You don't have coins! #{user.coins}")
    end
  end

  def minimum_bets?
    if self.user.coins < self.item.minimum_bets
      errors.add(:base, "You don't have enough coins! #{item.minimum_bets}")
    end
  end
end
