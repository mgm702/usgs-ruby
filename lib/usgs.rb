# frozen_string_literal: true

require "zeitwerk"
require "dry-configurable"
require "httparty"
require "json"

module Usgs
  @loader = Zeitwerk::Loader.for_gem
  @loader.enable_reloading
  @loader.setup

  extend Dry::Configurable
  setting :user_agent, default: -> { "Usgs Ruby Gem/#{VERSION}" }
  setting :timeout, default: 30
  setting :base_url, default: "https://waterservices.usgs.gov/nwis"
  setting :default_parameter, default: "DISCHRG"
  setting :debug, default: true

  class << self
    attr_reader :loader

    def client(**options)
      Usgs::Client.new(**options)
    end
  end
end
