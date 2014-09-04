require_relative '../phase6/controller_base'
require_relative './params'
require_relative './flash'

module Bonus
  class ControllerBase < Phase6::ControllerBase
    attr_reader :params
    attr_reader :flash

    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res)
      @params = Params.new(req, route_params)
      @flash = Flash.new
    end
  end
end
