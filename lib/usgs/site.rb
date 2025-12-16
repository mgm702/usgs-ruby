# frozen_string_literal: true

module Usgs
  module Site
    include Utils

    # Fetch USGS monitoring locations (sites)
    #
    # @param state_cd [String] Two-letter state code (e.g., "CO")
    # @param county_cd [String] FIPS county code (e.g., "08013")
    # @param huc [String] 2-16 digit Hydrologic Unit Code
    # @param bBox [String] "west,south,east,north" in decimal degrees
    # @param site_name [String] Text search in station name
    # @param site_type [String] e.g., "ST" (stream), "GW", "LK", "WE"
    # @param site_status [String] "active", "inactive", "all" (default: "all")
    # @param parameter_cd [String, Symbol, Array] e.g. :discharge, "00060", or [:discharge, :gage_height]
    #
    # @return [Array<Usgs::Models::Site>]
    # @raise [ArgumentError] if no major filter is provided
    #
    # @example
    #   Usgs.client.get_sites(state_cd: "CO", parameter_cd: :discharge)
    #
    def get_sites(state_cd: nil, county_cd: nil, huc: nil, bBox: nil, site_name: nil,
                  site_type: nil, site_status: "all", parameter_cd: nil)

      query = {
        format: "rdb,1.0",
        stateCd: state_cd,
        countyCd: county_cd,
        huc: huc,
        bBox: bBox,
        siteName: site_name,
        siteType: site_type,
        siteStatus: site_status
      }.compact

      if parameter_cd
        resolved = resolve_parameter_codes(parameter_cd)
        query[:parameterCd] = resolved if resolved && !resolved.empty?
      end

      # Validate for at least one major filter
      major_keys = %i[stateCd countyCd huc bBox].map(&:to_sym)
      if (query.keys & major_keys).empty?
        raise ArgumentError, "You must provide at least one major filter: state_cd, county_cd, huc or bBox"
      end

      raw = api_get("/site/", query)
      Parser.parse_sites(raw.body).map { |row| Models::Site.new(row) }
    end
  end
end
