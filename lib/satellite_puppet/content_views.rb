module SatellitePuppet
  class Content_views < SatellitePuppet::Base

    DEFINED_METHODS = {
      'content_views' => { :http_method => :get, :url_method_name => '' },
      'content_view_puppet_modules' => { :http_method => :post },
      'list_puppet_modules'         => { :http_method => :get, :url_method_name => 'content_view_puppet_modules' }
    }

    def update_puppet_module_in_cv(module_id, name)
      http_method = :put
      url = base_url
      url += "/#{sat_resource_name}"
      url += "/content_view_puppet_modules/"
      url += "#{module_id}"

      call_rest_method('put', url, http_method, args = name)
      puts "Updated puppet module in CV"
    end

  end
end

