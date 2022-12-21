class Banner < ApplicationRecord
  validates_presence_of :preview, :status, :online_at, :offline_at
  default_scope { where(deleted_at: nil) }
  mount_uploader :preview, ImageUploader

  def destroy
    update(deleted_at: Time.current)
  end

  enum status: { inactive: 0, active: 1 }
end
