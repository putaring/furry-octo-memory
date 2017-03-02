module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Roozam'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def notification_counter(count)
    content_tag(:span, count > 99 ? '99+' : count, class: 'tag tag-pill tag-danger') if count > 0
  end

end
