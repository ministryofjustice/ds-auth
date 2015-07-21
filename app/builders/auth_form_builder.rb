class AuthFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def field_with_error(name, &block)
    content = @template.capture(&block)

    if error_for_field?(name)
      content_tag :div, id: "field_#{name}", class: "field error" do
        content + error_messages_for(name)
      end
    else
      content_tag :div, id: "field_#{name}", class: "field" do
        content
      end
    end
  end

  def error_messages_for(field_name)
    content_tag :span, class: "error-message" do
      error_message field_name
    end
  end

  private

  def error_for_field?(field_name)
    @object.errors.has_key? field_name.to_sym
  end

  def error_message(field_name)
    ((@object.errors.messages.fetch field_name, []).join ", ").html_safe
  end
end
