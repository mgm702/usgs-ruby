# frozen_string_literal: true

module Usgs
  module Site
    # Fetch USGS monitoring locations (sites)
    #
    # @param state_cd [String] Two-letter state code (e.g., "CO", "CA")
    # @param county_cd [String] FIPS county code (e.g., "08013" for Boulder County, CO)
    # @param huc [String] Hydrologic Unit Code (8-digit or less)
    # @param bBox [String] Bounding box: "west,south,east,north" (decimal degrees)
    # @param site_type [String] Type of site (e.g., "ST" for stream, "GW" for groundwater)
    # @param site_status [String] "active", "inactive", or "all" (default: "all")
    # @param parameter_cd [String, Array] Parameter code(s) to filter sites that measure them
    #
    # @return [Array<Usgs::Models::Site>]
    #
    # @example Find all active stream gauges in Colorado
    #   Usgs.client.get_sites(state_cd: "CO", site_type: "ST", site_status: "active")
    #
    def get_sites(state_cd: nil, county_cd: nil, huc: nil, bBox: nil,
                  site_type: nil, site_status: "all", parameter_cd: nil)

      query = {
        format: "json",
        stateCd: state_cd,
        countyCd: county_cd,
        huc: huc,
        bBox: bBox,
        siteType: site_type,
        siteStatus: site_status,
        parameterCd: parameter_cd
      }.compact

      response = get_json("/site/", query)

      Parser.parse_sites(response)
    end
  end
end
