module SatellitePuppet
  class Content_view_versions < SatellitePuppet::Base

    DEFINED_METHODS = {
      'incremental_update' => { :http_method => :post }
    }
  end
end
