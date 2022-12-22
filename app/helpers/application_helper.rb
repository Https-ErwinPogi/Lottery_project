module ApplicationHelper
  def active_navbar(key, path)
    "#{key}" if current_page? path
  end

  def address_join(address)
    "#{address.street_address}, #{address.barangay.name}, #{address.city_municipality.name}, #{address.province.name}, #{address.region.name}"
  end

  def banners
    Banner.where('online_at <= ? AND offline_at > ?', Time.current, Time.current).active
  end

  def news_tickers
    NewsTicker.active.limit(5)
  end
end