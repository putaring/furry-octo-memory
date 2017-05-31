module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Spouzz'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def notification_counter(count)
    content_tag(:span, count > 99 ? '99+' : count, class: 'badge badge-pill badge-danger') if count > 0
  end

  def display_footer?
    !params[:controller].in?(["onboarding"]) &&
    !(params[:controller] == "me" && params[:action] == "verify")
  end

end
