module SatellitePuppet
  class Oranizations < SatellitePuppet::Base
    DEFINED_METHODS = {
      'environments' => {:http_method => :get }
    }
  end
end
