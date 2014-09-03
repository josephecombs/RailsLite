require 'uri'
require 'debugger'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = {}
      
      # debugger
      @params.merge!(route_params)
      if req.body
        @params.merge!(parse_www_encoded_form(req.body))    
      end
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
      
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    
    def parse_www_encoded_form(www_encoded_form)
      params = {}

      #www_encoded_form is a blob of text.  decode_www_form does some magic to convert to a hash.  for each pair in that hash check for sub hashes in the keys of the original hash
      # key_values = URI.decode_www_form(www_encoded_form)
      
      # debugger
      # key_values = URI.decode_www_form(www_encoded_form)
      #
      # params = key_values.deep_merge
      
      key_values = URI.decode_www_form(www_encoded_form)
      
      key_values.each do |full_key, value|
        scope = params
        
        key_seq = parse_key(full_key)
        key_seq.each_with_index do |k, i|
          if (i + 1) == key_seq.count
            scope[k] = value
          else
            scope[k] ||= {}
            scope = scope[k]            
          end
        end
      end      
      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\[|\]\[|\]/)
    end
  end
end
