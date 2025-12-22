# frozen_string_literal: true

require "test_helper"

module Usgs
  class TestInstantaneousValues < Minitest::Test
    def setup
      @client = Usgs::Client.new
    end

    def test_get_iv_basic
      VCR.use_cassette("usgs_get_iv_basic") do
        readings = @client.get_iv(
          sites: "06716500",
          parameter_cd: :discharge
        )

        assert_kind_of Array, readings
        refute_empty readings

        reading = readings.first

        assert_kind_of Hash, reading
        assert_includes reading.keys, :site_no
        assert_includes reading.keys, :datetime
        assert_includes reading.keys, :value
        assert_includes reading.keys, :qualifiers
      end
    end

    def test_get_iv_with_datetime_range
      VCR.use_cassette("usgs_get_iv_datetime_range") do
        readings = @client.get_iv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: DateTime.parse("2025-12-01T12:00"),
          end_date: DateTime.parse("2025-12-11T18:00")
        )

        assert_kind_of Array, readings
        refute_empty readings
      end
    end

    def test_get_iv_multiple_sites
      VCR.use_cassette("usgs_get_iv_multiple_sites") do
        readings = @client.get_iv(
          sites: %w[06716500 06752000],
          parameter_cd: :discharge
        )

        assert_kind_of Array, readings
        refute_empty readings
      end
    end

    def test_get_iv_different_parameter
      VCR.use_cassette("usgs_get_iv_temperature") do
        readings = @client.get_iv(
          sites: "06754000",
          parameter_cd: :temperature
        )

        assert_kind_of Array, readings
      end
    end

    def test_get_iv_multiple_parameters
      VCR.use_cassette("usgs_get_iv_multiple_parameters") do
        readings = @client.get_iv(
          sites: "06754000",
          parameter_cd: %i[discharge gage_height]
        )

        assert_kind_of Array, readings
      end
    end

    def test_get_iv_invalid_parameter
      assert_raises(ArgumentError) do
        @client.get_iv(
          sites: "06754000",
          parameter_cd: :invalid_param
        )
      end
    end

    def test_iv_numeric_values
      VCR.use_cassette("usgs_get_iv_numeric") do
        readings = @client.get_iv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: DateTime.parse("2025-12-01T12:00"),
          end_date: DateTime.parse("2025-12-11T18:00")
        )

        refute_empty readings

        reading = readings.first
        assert_kind_of Float, reading[:value] unless reading[:value].nil?
      end
    end

    def test_iv_datetime_formatting
      VCR.use_cassette("usgs_get_iv_datetimes") do
        readings = @client.get_iv(
          sites: "06716500",
          parameter_cd: :discharge,
          start_date: DateTime.parse("2025-12-01T12:00"),
          end_date: DateTime.parse("2025-12-11T18:00")
        )

        refute_empty readings

        reading = readings.first

        assert_includes reading.keys, :datetime
        assert_kind_of String, reading[:datetime] unless reading[:datetime].nil?
      end
    end
  end
end
