require_relative '../phase3/controller_base'
require_relative './session'
require 'debugger'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      #user parent methods
      super(url)
      session.store_session(@res)
      nil
    end

    def render_content(content, type)
      #user parent methods
      super(content, type)
      session.store_session(@res)
      nil
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
  end
end
