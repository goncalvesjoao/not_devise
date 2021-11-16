module ApplicationHelper
  def flash_message(message, type = 'alert')
    bg_class = { 'alert' => 'danger', 'notice' => 'success' }[type]

    content_tag(:div, class: "alert alert-#{bg_class} d-flex", role: 'alert') do
      content_tag(:div, message, class: 'flex-fill') +
      content_tag(:button, '', class: 'btn-close', type: 'button', data: { bs_dismiss: 'alert' }, aria_label: 'Close')
    end
  end

  def flash_messages
    content_tag(:div, class: 'row justify-content-md-center') do
      content_tag(:div, class: 'col-12 col-lg-6') do
        flash.each do |type, message|
          concat flash_message(message, type)
        end
      end
    end
  end
end
