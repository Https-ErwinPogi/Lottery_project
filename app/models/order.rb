class Order < ApplicationRecord
  validates :amount, numericality: { greater_than_or_equal: 0 }
  belongs_to :user
  belongs_to :offer
  after_create :generate_serial_number
  after_validation :check_amount

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :deduct?, after: [:cancel_update_user_coins, :decrease_total_deposit]
      transitions from: :paid, to: :cancelled,
                  guards: [:enough_user_coins?], if: proc { !deduct? },
                  after: [:cancel_update_user_coins, :decrease_total_deposit]
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :not_deduct?, after: [:pay_update_user_coins, :increase_total_deposit]
      transitions from: :submitted, to: :paid, guard: :enough_user_coins?, after: [:pay_update_user_coins, :increase_total_deposit]
    end
  end

  def generate_serial_number
    number_count = Order.where(user_id: user.id).count.to_s.rjust(4, '0')
    self.update!(serial_number: "#{Time.current.strftime("%y%m%d")}-#{id}-#{user.id}-#{number_count}")
  end

  def pay_update_user_coins
    if deduct?
      user.update!(coins: user.coins - self.coin)
    else
      user.update!(coins: user.coins + self.coin)
    end
  end

  def increase_total_deposit
    if deposit?
      user.update!(total_deposit: user.total_deposit + self.amount)
    end
  end

  def cancel_update_user_coins
    if deduct?
      user.update!(coins: user.coins + self.coin)
    else
      user.update!(coins: user.coins - self.coin)
    end
  end

  def not_deduct?
    !deduct?
  end

  def enough_user_coins?
    self.user.coins >= self.coin
  end

  def decrease_total_deposit
    if deposit?
      user.update!(total_deposit: user.total_deposit - self.amount)
    end
  end

  def check_amount
    if deposit?
      amount >= 1
    end
  end
end
