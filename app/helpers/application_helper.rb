module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Roozam'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def show_main_nav?
    !(params[:controller] == "users" && (params[:action].in?(%w(new create))))
  end
end
