# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def nav_link_to(text, url, options = {})
    link_to(text, url, options.merge(class: nav_link_class(url)))
  end

  def nav_link_class(url)
    page_active?(url) ? 'active' : ''
  end

  def page_active?(url)
    current_page?(url) ||
      if url == games_path
        current_page?(root_path)
      else
        false
      end
  end
end
