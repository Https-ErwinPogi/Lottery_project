class MemberLevel < ApplicationRecord
  validates_presence_of :level, :coins, :required_members
  validates_uniqueness_of :required_members, :level
  has_many :users
  default_scope { order(:required_members) }

end
