class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city_municipality, optional: true
  has_many :addresses, class_name: 'Addresses', foreign_key: 'address_barangay_id'
end
