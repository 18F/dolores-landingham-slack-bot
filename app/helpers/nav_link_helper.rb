module NavLinkHelper
  def nav_link(link_text, link_path)

    class_name = current_page?(link_path) ? 'current' : nil

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def is_current(paths)
    is_array = paths.is_a?(Array)

    if is_array
      paths.each do |path|
        if request.fullpath.include? path
          return true
        end
      end
    else
      if request.fullpath.include? paths
        return true
      end
    end

    return false
  end
end

