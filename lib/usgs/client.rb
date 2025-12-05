# frozen_string_literal: true
require 'pry'

module Usgs
  class Client
    include Site
    include InstantaneousValues
    include Statistics

    attr_reader :timeout, :user_agent

    def initialize(timeout: 30, user_agent: "usgs-ruby/#{Usgs::VERSION}", debug: false)
      @timeout    = timeout
      @user_agent = user_agent
      @debug = debug
    end

    # Base URL for USGS Water Services
    def base_url
      "https://waterservices.usgs.gov/nwis"
    end

    # Public: Perform GET and return parsed JSON
    def api_get(path, query = {})
      query = query.compact
      url   = "#{base_url}#{path}"

      # binding.pry
      fetch_url(url, query: query, timeout: timeout, user_agent: user_agent)
    end

    private

    def fetch_url(url, query: {}, timeout: 30, user_agent: nil)
      uri = URI(url)
      uri.query = URI.encode_www_form(query) unless query.empty?

      puts "\n=== USGS Request ===\n#{uri}\n====================\n" if $DEBUG || ENV["USGS_DEBUG"]

      http_get(uri, timeout: timeout, user_agent: user_agent)
    end

    def http_get(uri, timeout: 30, user_agent: nil)
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: true,
        open_timeout: timeout,
        read_timeout: timeout
      ) do |http|
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = user_agent if user_agent
        request["Accept"]     = "application/json"

        response = http.request(request)

        if response.is_a?(Net::HTTPSuccess)
          response
        else
          raise "USGS API Error #{response.code}: #{response.message}\n#{response.body}"
        end
      end
    end
  end
end
