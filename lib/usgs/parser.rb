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

      def parse_instantaneous_values(response)
        Parsers::InstantaneousValuesParser.parse_instantaneous_values(response)
      end
    end
  end
end
