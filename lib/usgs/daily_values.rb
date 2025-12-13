# lib/usgs/daily_values.rb
# frozen_string_literal: true

module Usgs
  module DailyValues
    include Utils
    # Fetch daily values (DV) from USGS NWIS
    #
    # @param sites [String, Array<String>] USGS site ID(s)
    # @param parameter_cd [Symbol, String, Array] e.g. :discharge
    # @param start_date [Date, String, nil] Start date — defaults to 10 years ago if omitted
    # @param end_date [Date, String, nil] End date — defaults to today
    #
    # @return [Array<Usgs::Models::Reading>]
    #
    # @example Most recent year
    #   Usgs.client.get_dv(sites: "06754000", parameter_cd: :discharge)
    #
    # @example Full POR
    #   Usgs.client.get_dv(sites: "06754000", parameter_cd: :discharge, start_date: "1900-01-01")
    #
    def get_dv(sites:, parameter_cd: nil, start_date: nil, end_date: nil)
      site_list  = Array(sites).join(",")
      param_list = resolve_parameter_codes(parameter_cd)

      query = {
        format: "json",
        sites: site_list,
        parameterCd: param_list,
        startDT: format_date(start_date || (Time.now.utc - (24 * 60 * 60))),
        endDT: format_date(end_date || Time.now.utc)
      }.compact

      response = api_get("/dv/", query)
      Parser.parse_time_series_values(JSON.parse(response.body))
    end
  end
end
