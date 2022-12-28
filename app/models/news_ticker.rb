class NewsTicker < ApplicationRecord
  validates_presence_of :content, :sort, :status
  belongs_to :admin, class_name: "User"
  default_scope { where(deleted_at: nil) }
  default_scope { order(:sort) }

  def destroy
    update(deleted_at: Time.current)
  end

  enum status: { inactive: 0, active: 1 }
end
