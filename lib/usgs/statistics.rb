# frozen_string_literal: true

module Usgs
  module Statistics
    # Fetch statistics from USGS NWIS
    #
    # @param sites [String, Array<String>] USGS site ID(s)
    # @param parameter_cd [Symbol, String, Array] e.g. :discharge
    # @param report_type [Symbol] :daily, :monthly, or :annual (default: :daily)
    # @param stat_year_type [String, nil] "water", "calendar", "all" — only for :annual
    #
    # @return [Array<Usgs::Models::Statistic>]
    #
    # @example
    #   Usgs.client.get_stats(sites: "06754000", report_type: :daily)
    #   Usgs.client.get_stats(sites: "06754000", report_type: :monthly, parameter_cd: :discharge)
    #   Usgs.client.get_stats(sites: "06754000", report_type: :annual, stat_year_type: "water")
    #
    def get_stats(sites:, parameter_cd: nil, report_type: :daily, stat_year_type: nil)
      site_list   = Array(sites).join(",")
      param_list  = resolve_parameter_codes(parameter_cd)
      type_str    = report_type.to_s

      raise ArgumentError, "report_type must be :daily, :monthly, or :annual" unless %w[daily monthly annual].include?(type_str)

      raise ArgumentError, "stat_year_type is only valid when report_type: :annual" if type_str != "annual" && stat_year_type

      query = {
        format: "rdb,1.0",
        sites: site_list,
        parameterCd: param_list,
        statReportType: type_str,
        statTypeCd: "all"
      }

      query[:statYearType] = stat_year_type if stat_year_type

      raw = api_get("/stat/", query)
      Parser.parse_statistics(raw.body).map { |row| Models::Statistic.new(row) }
    end
  end
end
