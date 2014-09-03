require 'json'
require 'webrick'
require 'debugger'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      # session[]
      cookie = req.cookies.find { |c| c.name == "_rails_lite_app"}
      # puts req

      if cookie
        # JSON.parse(cookie)
        #above will not work
        @data = JSON.parse(cookie.value)
      else
        @data = {}
      end
    end

    def [](key)
      @data[key]
    end

    def []=(key, val)
      @data[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new( "_rails_lite_app", @data.to_json )
    end
  end
end
