module ApplicationHelper
  def full_title(page_title = '')
    full_title = "Rails Book"
    unless page_title.empty?
        full_title = "#{page_title} | #{full_title}"
    end
    return full_title
  end
end
