module ApplicationHelper
  def i18n_connector(*keys)
    title = ""
    keys.each do |key|
      title << t(key)
    end
    return title
  end
end
