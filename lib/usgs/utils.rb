# frozen_string_literal: true

module Usgs
  module Utils
    # Perform HTTP GET with timeout and headers
    def http_get(uri, timeout: 30, user_agent: nil)
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: timeout,
        read_timeout: timeout
      ) do |http|
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = user_agent if user_agent
        request["Accept"]     = "application/json"

        response = http.request(request)

        case response
        when Net::HTTPSuccess
          response
        else
          raise "USGS API Error #{response.code}: #{response.message}\n#{response.body}"
        end
      end
    end

    # Enable debug logging globally
    def self.debug!
      @debug = true
    end

    def self.debug?
      !!@debug
    end
  end
end
