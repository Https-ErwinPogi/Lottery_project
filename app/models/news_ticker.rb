class NewsTicker < ApplicationRecord
  validates :content, presence: true
  belongs_to :admin, class_name: "User"

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  enum status: { inactive: 0, active: 1 }
end
