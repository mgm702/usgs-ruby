# frozen_string_literal: true

module Usgs
  # Provides utility methods for handling dates, query parameters, and API pagination.
  #
  # This module contains helper methods used across the CDSS API client for
  # data formatting, safe type conversion, and managing paginated responses.
  module Utils
    # Convert symbols to official USGS parameter codes
    def resolve_parameter_codes(codes)
      return nil if codes.nil?

      mapping = {
        discharge:      "00060",
        gage_height:    "00065",
        temperature:    "00010",
        precipitation:  "00045",
        do:             "00300",
        conductivity:   "00095",
        ph:             "00400"
      }

      Array(codes).map { |c| mapping[c.to_sym] || c.to_s }.join(",")
    end

    def format_date(date)
      Date.parse(date.to_s).strftime("%Y-%m-%d")
    rescue
      Date.today.strftime("%Y-%m-%d")
    end

    def format_datetime(dt)
      return nil unless dt
      Time.parse(dt.to_s).utc.strftime("%Y-%m-%dT%H:%M")
    end
  end
end
