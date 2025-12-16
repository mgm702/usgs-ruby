# frozen_string_literal: true

require "test_helper"

module Usgs
  class TestSite < Minitest::Test
    def setup
      @client = Usgs::Client.new
    end

    def test_get_sites_by_state
      VCR.use_cassette("usgs_get_sites_state") do
        sites = @client.get_sites(state_cd: "CO")

        assert_kind_of Array, sites
        refute_empty sites

        site = sites.first

        assert_kind_of Usgs::Models::Site, site
        assert_respond_to site, :site_no
        assert_respond_to site, :station_nm
        assert_respond_to site, :dec_lat_va
        assert_respond_to site, :dec_long_va
      end
    end

    def test_get_sites_by_county
      VCR.use_cassette("usgs_get_sites_county") do
        sites = @client.get_sites(county_cd: "08013")

        assert_kind_of Array, sites
        refute_empty sites
      end
    end

    def test_get_sites_by_huc
      VCR.use_cassette("usgs_get_sites_huc") do
        sites = @client.get_sites(huc: "10190005")

        assert_kind_of Array, sites
        refute_empty sites
      end
    end

    def test_get_sites_with_parameter
      VCR.use_cassette("usgs_get_sites_parameter") do
        sites = @client.get_sites(
          state_cd: "CO",
          parameter_cd: :discharge
        )

        assert_kind_of Array, sites
        refute_empty sites
      end
    end

    def test_get_sites_with_site_type
      VCR.use_cassette("usgs_get_sites_type") do
        sites = @client.get_sites(
          state_cd: "CO",
          site_type: "ST"
        )

        assert_kind_of Array, sites
        refute_empty sites
      end
    end

    def test_get_sites_by_name
      VCR.use_cassette("usgs_get_sites_name") do
        sites = @client.get_sites(state_cd: "CO", site_name: "Boulder Creek")

        assert_kind_of Array, sites
      end
    end

    def test_get_sites_by_bbox
      VCR.use_cassette("usgs_get_sites_bbox") do
        sites = @client.get_sites(bBox: "-105.5,39.5,-105.0,40.0")

        assert_kind_of Array, sites
        refute_empty sites
      end
    end

    def test_get_sites_no_major_filter
      assert_raises(ArgumentError) do
        @client.get_sites(site_type: "ST")
      end
    end

    def test_get_sites_invalid_parameter
      assert_raises(ArgumentError) do
        @client.get_sites(
          state_cd: "CO",
          parameter_cd: :invalid_param
        )
      end
    end
  end
end
