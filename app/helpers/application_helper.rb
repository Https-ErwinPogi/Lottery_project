module ApplicationHelper
  def active_navbar(key, path)
    "#{key}" if current_page? path
  end

  def address_join(address)
    "#{address.street_address}, #{address.barangay.name}, #{address.city_municipality.name}, #{address.province.name}, #{address.region.name}"
  end
end