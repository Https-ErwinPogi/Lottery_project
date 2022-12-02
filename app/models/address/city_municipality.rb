class Address::CityMunicipality < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province
  has_many :barangays
  has_many :addresses, class_name: 'Addresses', foreign_key: 'address_city_municipality_id'
end
