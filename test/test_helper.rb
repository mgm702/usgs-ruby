# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "usgs"

require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"
require "vcr"
require "active_support"
require "active_support/testing/time_helpers"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = false

  # Automatically delete cassettes if response is 404 or body is empty
  config.after_http_request do |_request, response|
    if response&.status&.code == 404 || response&.body.nil? || response&.body&.empty?
      cassette_path = VCR.current_cassette&.file
      if cassette_path && File.exist?(cassette_path)
        File.delete(cassette_path)
        puts "Deleted cassette: #{cassette_path} (due to 404 or empty response)"
      end
    end
  end

  config.default_cassette_options = {
    record: :once,
    match_requests_on: [:method, VCR.request_matchers.uri_without_params(:startDT, :endDT)]
  }
end

Usgs.config.user_agent = -> { "USGS Test" }
