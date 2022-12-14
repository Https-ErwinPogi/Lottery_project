module ApplicationHelper
  def active_navbar(key, path)
    "#{key}" if current_page? path
  end
end