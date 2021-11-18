# frozen_string_literal: true

module ApplicationHelper
  def flash_message(message, type = 'alert')
    bg_class = { 'alert' => 'danger', 'notice' => 'success', 'warning' => 'warning' }[type]

    content_tag(:div, class: "alert alert-#{bg_class} d-flex", role: 'alert') do
      content_tag(:div, message, class: 'flex-fill') +
        content_tag(:button, '', class: 'btn-close', type: 'button', data: { bs_dismiss: 'alert' }, aria_label: 'Close')
    end
  end

  def flash_messages
    flash.map do |type, message|
      flash_message(message, type)
    end.join('').html_safe
  end
end
