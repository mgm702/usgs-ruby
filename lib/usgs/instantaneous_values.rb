# frozen_string_literal: true

module Usgs
  module InstantaneousValues
    include Utils
    # Fetch instantaneous values (IV) from USGS NWIS
    #
    # @param sites [String, Array<String>] One or more USGS site IDs
    # @param parameter_cd [Symbol, String, Array] e.g. :discharge, "00060", or [:discharge, :gage_height]
    # @param start_date [DateTime, Date, Time, String, nil] Start time
    # @param end_date [DateTime, Date, Time, String, nil] End time (default: now)
    #
    # @return [Array<Usgs::Models::Reading>]
    #
    # @example
    #   Usgs.client.get_iv(sites: "06754000", parameter_cd: :discharge, start_date: 1.day.ago)
    #
    def get_iv(sites:, parameter_cd: nil, start_date: nil, end_date: nil)
      site_list = Array(sites).join(",")
      param_list = resolve_parameter_codes(parameter_cd)

      query = {
        format: "json",
        sites: site_list,
        parameterCd: param_list,
        # Default to the the last 24hrs if not filled out
        startDT: format_datetime(start_date || (Time.now.utc - (24 * 60 * 60))),
        endDT: format_datetime(end_date || Time.now.utc)
      }.compact

      response = api_get("/iv/", query)
      Parser.parse_time_series_values(JSON.parse(response.body))
    end
  end
end
