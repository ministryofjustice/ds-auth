module ApplicationHelper
  def flash_messages(opts = {})
    flash.to_h.slice('notice', 'alert').each do |msg_type, message|
      concat(content_tag(:div, message, class: "#{msg_type}-summary") do
        content_tag(:p, message) do
          concat safe_join(Array(message), tag(:br))
        end
      end)
    end
    nil
  end

  def list_errors(object, field_name)
    if object.errors.any?
      unless object.errors.messages[field_name].blank?
        content_tag :ul do
          object.errors.messages[field_name].collect do |field|
            concat(content_tag(:li, field))
          end
        end
      end
    end
  end
end
