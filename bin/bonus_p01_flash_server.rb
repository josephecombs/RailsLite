require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/bonus/controller_base'
require 'debugger'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class Cat
  
  attr_reader :name, :owner, :validation_errors

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    # params["name"].length > 1 ? @name = params["name"] : @name = params["name"] + "_"
    @name = params["name"]
    @owner = params["owner"]
    @validation_errors = []
  end

  def save
    if validated?
      Cat.all << self
      return true
    else
      return false
    end
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
  
  def validated?
    @validation_errors = []
    @validation_errors << "Name must be present" unless @name.present?
    @validation_errors << "Owner must be present" unless @owner.present?
    @validation_errors << "Owner name must be greater than 1 character" unless @owner.length > 1
    
    if @validation_errors.count > 0
      return false
    else
      return true
    end
  end
end

class CatsController < Bonus::ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      redirect_to("/cats")
    else
      flash.now[:errors] = @cat.validation_errors
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  case [req.request_method, req.path]
  when ['GET', '/cats']
    CatsController.new(req, res, {}).index
  when ['POST', '/cats']
    CatsController.new(req, res, {}).create
  when ['GET', '/cats/new']
    CatsController.new(req, res, {}).new
  end
end

trap('INT') { server.shutdown }
server.start