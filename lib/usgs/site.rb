# frozen_string_literal: true
include 'pry'

module Usgs
  module Site
    MAJOR_FILTERS = %i[state_cd county_cd huc bBox site_name].freeze

    # Fetch USGS monitoring locations (sites)
    #
    # @param state_cd [String] Two-letter state code (e.g., "CO")
    # @param county_cd [String] FIPS county code (e.g., "08013")
    # @param huc [String] 2-16 digit Hydrologic Unit Code
    # @param bBox [String] "west,south,east,north" in decimal degrees
    # @param site_name [String] Text search in station name
    # @param site_type [String] e.g., "ST" (stream), "GW", "LK", "WE"
    # @param site_status [String] "active", "inactive", "all" (default: "all")
    # @param parameter_cd [String, Array<String>] 5-digit parameter code(s) or symbols
    #
    # @return [Array<Usgs::Models::Site>]
    # @raise [ArgumentError] if no major filter is provided
    #
    # @example
    #   Usgs.client.get_sites(state_cd: "CO", site_type: "ST")
    #
    def get_sites(state_cd: nil, county_cd: nil, huc: nil, bBox: nil, site_name: nil,
                  site_type: nil, site_status: "all", parameter_cd: nil)

      query = {
        format: "json",
        stateCd: state_cd,
        countyCd: county_cd,
        huc: huc,
        bBox: bBox,
        siteName: site_name,
        siteType: site_type,
        siteStatus: site_status
      }.compact

      # Handle parameterCd separately to avoid syntax error with conditional
      if parameter_cd
        codes = Array(parameter_cd).map { |p| PARAMETER_CODES[p] || p }.join(",")
        query[:parameterCd] = codes unless codes.empty?
      end

      # Validate that at least one major filter is present
      provided_filters = query.keys.intersect?(%i[stateCd countyCd huc bBox siteName].map(&:to_sym))
      if query.except(:format, :siteType, :siteStatus, :parameterCd).empty? && !provided_filters
        raise ArgumentError, "You must provide at least one major filter: state_cd, county_cd, huc, bBox, or site_name"
      end

      response = get_json("/site/", query)
      Parser.parse_sites(response)
    end

    # Common parameter codes — can be used as symbols
    PARAMETER_CODES = {
      discharge: "00060",
      gage_height: "00065",
      temperature: "00010",
      precipitation: "00045",
      dissolved_oxygen: "00300",
      ph: "00400",
      conductivity: "00095"
    }.freeze
  end
end
