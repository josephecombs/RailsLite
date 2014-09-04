require 'uri'
require 'debugger'

module Bonus
  class Flash
    attr_accessor :errors
    
    def initialize
      @errors = {}
    end
    
    def now
      @errors
    end
  end
end
