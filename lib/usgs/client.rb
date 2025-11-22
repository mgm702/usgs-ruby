# frozen_string_literal: true

module Usgs
  # Main client class for interacting with USGS Water Services API
  #
  # @example Basic usage
  #   Usgs.client.get_sites(state_cd: "CO")
  #
  # @example With custom timeout
  #   client = Usgs::Client.new(timeout: 60)
  class Client
    include HTTParty
    base_uri Usgs.config.base_url

    include Site
    include InstantaneousValues
    include DailyValues

    attr_reader :timeout, :user_agent

    # Initialize a new USGS client
    #
    # @param timeout [Integer] Request timeout in seconds (default: 30)
    # @param user_agent [String] Custom User-Agent header
    def initialize(timeout: 30, user_agent: "usgs-ruby/#{Usgs::VERSION}")
      @timeout     = timeout
      @user_agent  = user_agent
    end

    # Perform a GET request and parse JSON response
    #
    # @param path [String] API endpoint path
    # @param query [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def get_json(path, query = {})
      query = query.compact
      url   = "#{base_url}#{path}"

      response = fetch_url(url, query: query, timeout: timeout, user_agent: user_agent)
      JSON.parse(response.body)
    end

    private

    # Low-level fetch with debug support
    #
    # @private
    def fetch_url(url, query: {}, timeout: 30, user_agent: nil)
      uri = build_uri(url, query)

      if Usgs.instance_variable_defined?(:@debug) && Usgs.instance_variable_get(:@debug)
        puts "\n=== USGS API Request ==="
        puts "URL: #{uri}"
        puts "=======================\n"
      end

      http_get(uri, timeout: timeout, user_agent: user_agent)
    end
  end
end
