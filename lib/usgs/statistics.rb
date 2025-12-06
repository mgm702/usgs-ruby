# frozen_string_literal: true

module Usgs
  module Statistics
    # Fetch daily statistics (all percentiles) for one or more sites
    #
    # @param sites [String, Array<String>] USGS site ID(s)
    # @param parameter_cd [Symbol, String, Array] e.g. :discharge, "00060"
    #
    # @return [Array<Usgs::Models::Statistic>]
    def get_stats(sites:, parameter_cd: nil)
      site_list = Array(sites).join(",")
      param_list = resolve_parameter_codes(parameter_cd)

      query = {
        format: "rdb,1.0",
        sites: site_list,
        parameterCd: param_list,
        statReportType: "daily",   # fixed: always "daily"
        statTypeCd: "all"
        # statYearType: removed — not allowed for daily stats
      }.compact

      binding.pry
      raw = api_get("/stat/", query)
      Parser.parse_statistics(raw.body).map { |row| Models::Statistic.new(row) }
    end

    private

    def resolve_parameter_codes(codes)
      return nil if codes.nil?

      mapping = {
        discharge:      "00060",
        gage_height:    "00065",
        temperature:    "00010",
        precipitation:  "00045"
      }

      Array(codes).map { |c| mapping[c.to_sym] || c.to_s }.join(",")
    end
  end
end
