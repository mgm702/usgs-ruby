# frozen_string_literal: true

require "test_helper"

module Usgs
  class TestStatistics < Minitest::Test
    def setup
      @client = Usgs::Client.new
    end

    def test_get_stats_daily
      VCR.use_cassette("usgs_get_stats_daily") do
        stats = @client.get_stats(
          sites: "06716500",
          report_type: :daily
        )

        assert_kind_of Array, stats
        refute_empty stats

        stat = stats.first

        assert_kind_of Usgs::Models::Statistic, stat
        assert_respond_to stat, :site_no
        assert_respond_to stat, :parameter_cd
        assert_respond_to stat, :begin_yr
        assert_respond_to stat, :end_yr
      end
    end

    def test_get_stats_monthly
      VCR.use_cassette("usgs_get_stats_monthly") do
        stats = @client.get_stats(
          sites: "06716500",
          report_type: :monthly
        )

        assert_kind_of Array, stats
        refute_empty stats
      end
    end

    def test_get_stats_annual
      VCR.use_cassette("usgs_get_stats_annual") do
        stats = @client.get_stats(
          sites: "06716500",
          report_type: :annual
        )

        assert_kind_of Array, stats
        refute_empty stats
      end
    end

    def test_get_stats_annual_with_year_type
      VCR.use_cassette("usgs_get_stats_annual_water") do
        stats = @client.get_stats(
          sites: "06716500",
          report_type: :annual,
          stat_year_type: "water"
        )

        assert_kind_of Array, stats
        refute_empty stats
      end
    end

    def test_get_stats_with_parameter
      VCR.use_cassette("usgs_get_stats_parameter") do
        stats = @client.get_stats(
          sites: "06716500",
          parameter_cd: :discharge,
          report_type: :daily
        )

        assert_kind_of Array, stats
        refute_empty stats
      end
    end

    def test_get_stats_invalid_report_type
      assert_raises(ArgumentError) do
        @client.get_stats(
          sites: "06716500",
          report_type: :invalid
        )
      end
    end

    def test_get_stats_year_type_with_non_annual
      assert_raises(ArgumentError) do
        @client.get_stats(
          sites: "06716500",
          report_type: :daily,
          stat_year_type: "water"
        )
      end
    end

    def test_get_stats_invalid_parameter
      assert_raises(ArgumentError) do
        @client.get_stats(
          sites: "06716500",
          parameter_cd: :invalid_param,
          report_type: :daily
        )
      end
    end
  end
end
