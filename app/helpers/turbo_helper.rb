# frozen_string_literal: true

module TurboHelper
  def flash_message(message)
    html_flash = "<div data-controller=\"flashes\" class=\"hidden\" data-flashes-message-value=\"#{message}\"></div>".html_safe
    turbo_stream.append(:flash_messages, html_flash)
  end
end
