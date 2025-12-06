# frozen_string_literal: true

module Usgs
  class Parser
    class << self
      def parse_sites(response)
        Parsers::RdbParser.parse(response)
      end

      def parse_time_series(response, timescale: :instantaneous)
        # Parsers::TimeSeriesParser.parse(response, timescale: timescale)
      end

      def parse_time_series_values(response)
        Parsers::TimeSeriesParser.parse(response)
      end

      def parse_statistics(response)
        Parsers::StatisticsParser.parse(response)
      end
    end
  end
end
