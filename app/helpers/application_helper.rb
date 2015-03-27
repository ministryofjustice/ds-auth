module ApplicationHelper
  def flash_messages
    if flash.any?
      capture do
        flash.each do |key, msg|
          concat flash_message(key, msg)
        end
      end
    end
  end

  def flash_message(key, msg)
    content_tag(:div, class: "#{key}-summary") do
      content_tag :p, msg
    end
  end

  def object_error_messages(active_model_messages)
    content_tag(:ul) do
      active_model_messages.each do |field_name, field_messages|
        concat errors_for_field(field_name, field_messages)
      end
    end
  end

  def errors_for_field field_name, field_messages
    content_tag :li do
      "#{t(field_name)}: #{field_messages.join(', ')}".html_safe
    end
  end
end
