# frozen_string_literal: true

module ApplicationHelper
  def ajax_flash(div_id)
    flash_div = ""

    flash.each do |name, msg|
      if msg.is_a?(String)
        flash_div = "<div class=\"alert alert-#{name == :notice ? 'success' : 'error'} ajax_flash\"> <div id=\"flash_#{name == :notice ? 'notice' : 'error'}\">#{h(msg)}</div> </div>"
      end
    end

    response = "$('.alert').remove();$('#{div_id}').prepend('#{flash_div}');" || ''
    response.html_safe
  end
end
