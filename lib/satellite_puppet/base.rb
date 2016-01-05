module SatellitePuppet
  class Base
    attr_accessor :sat_resource_name

    self.class::DEFINED_METHODS = {}

    def initialize(sat_resource_name=nil)
      @sat_resource_name = sat_resource_name
    end

    def method_missing(meth, *args, &block)
      method_name = meth.to_s
#      args = args.first
      if method_def = self.class::DEFINED_METHODS[method_name]
        rest_url = full_url(method_name, method_def)
        call_rest_method(method_name, rest_url, method_def[:http_method], args)
      else
        super
      end
    end

    protected

    def call_rest_method(method_name, rest_url, http_method, args)
      args = args.to_json if args
      begin
        RestClient::Request.new(
          :method     => http_method,
          :url        => rest_url,
          :headers    => { :accept => :json, :content_type => :json },
          :verify_ssl => false,
          :payload    => args
          ).execute
      rescue => e
        puts e.response
      end
    end

    def short_class_name
      self.class.name.to_s.sub(/^.*::/, '')
    end

    def base_url
      "#{SatellitePuppet.base_url}/#{short_class_name.downcase}"
    end

    def full_url(method_name, method_def)
      url = base_url
      url += "/#{@sat_resource_name}" if @sat_resource_name
      url_method_name = method_def[:url_method_name] || method_name
      url += "/#{url_method_name}" unless (url_method_name.nil? || url_method_name.empty?)
      url += '/'
      return url
    end

  end

end


