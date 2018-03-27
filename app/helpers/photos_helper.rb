module PhotosHelper
  def photo_caption_for(photo)
    content_tag :div do
      if photo.caption.present?
        content_tag :span, "#{photo.caption.truncate(27)} ✎", title: photo.caption
      else
        content_tag :span, "Add a caption ✎", class: 'font-italic'
      end
    end
  end
end
