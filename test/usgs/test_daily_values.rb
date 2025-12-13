# frozen_string_literal: true

require "test_helper"

module Usgs
  class TestDailyValues < Minitest::Test
    def setup
      @client = Usgs::Client.new
    end

    def test_get_dv_basic
      VCR.use_cassette("usgs_get_dv_basic") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: :discharge
        )

        assert_kind_of Array, readings
        refute_empty readings

        reading = readings.first

        assert_kind_of Usgs::Models::Reading, reading
        assert_respond_to reading, :site_no
        assert_respond_to reading, :date_time
        assert_respond_to reading, :value
        assert_respond_to reading, :qualifiers
      end
    end

    def test_get_dv_with_date_range
      VCR.use_cassette("usgs_get_dv_date_range") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: Date.parse("2023-01-01"),
          end_date: Date.parse("2023-12-31")
        )

        assert_kind_of Array, readings
        refute_empty readings
      end
    end

    def test_get_dv_multiple_sites
      VCR.use_cassette("usgs_get_dv_multiple_sites") do
        readings = @client.get_dv(
          sites: ["06754000", "06716500"],
          parameter_cd: :discharge
        )

        assert_kind_of Array, readings
        refute_empty readings
      end
    end

    def test_get_dv_different_parameter
      VCR.use_cassette("usgs_get_dv_temperature") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: :temperature
        )

        assert_kind_of Array, readings
      end
    end

    def test_get_dv_multiple_parameters
      VCR.use_cassette("usgs_get_dv_multiple_parameters") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: [:discharge, :gage_height]
        )

        assert_kind_of Array, readings
      end
    end

    def test_get_dv_invalid_parameter
      assert_raises(ArgumentError) do
        @client.get_dv(
          sites: "06716500",
          parameter_cd: :invalid_param
        )
      end
    end

    def test_dv_numeric_values
      VCR.use_cassette("usgs_get_dv_numeric") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: Date.parse("2023-01-01"),
          end_date: Date.parse("2023-01-31")
        )

        refute_empty readings

        reading = readings.first
        assert_kind_of Float, reading.value unless reading.value.nil?
      end
    end

    def test_dv_date_formatting
      VCR.use_cassette("usgs_get_dv_dates") do
        readings = @client.get_dv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: "2023-06-01",
          end_date: "2023-06-30"
        )

        refute_empty readings

        reading = readings.first

        assert_respond_to reading, :datetime
        assert_kind_of Date, reading.datetime unless reading.datetime.nil?
      end
    end
  end
end
