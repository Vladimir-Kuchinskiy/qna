# frozen_string_literal: true

module ApplicationHelper
  def ajax_flash(div_id)
    flash_div = ''

    flash.each do |name, msg|
      next unless msg.is_a?(String)

      flash_div = "<div class=\"alert alert-#{name == 'notice' ? 'success' : 'danger'} ajax_flash\">"\
                    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">'\
                     '<span aria-hidden="true">&times;</span>'\
                    "</button> #{h(msg)}"\
                   '</div>'
    end

    response = "$('.alert').remove();$('#{div_id}').prepend('#{flash_div}');" || ''
    response.html_safe
  end
end
