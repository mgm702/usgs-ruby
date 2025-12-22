# frozen_string_literal: true

module Usgs
  module Parsers
    module TimeSeriesParser
      class << self
        # Parse both Instantaneous Values (IV) and Daily Values (DV)
        # They have identical JSON structure
        def parse(response)
          series_list = response.dig("value", "timeSeries") || []
          series_list.flat_map { |series| parse_series(series) }
        end

        private

        def parse_series(series)
          info     = series["sourceInfo"]
          variable = series["variable"]
          values   = series["values"]&.first&.dig("value") || []

          site_no      = info.dig("siteCode", 0, "value")
          parameter_cd = variable.dig("variableCode", 0, "value")
          unit         = variable.dig("unit", "unitCode")

          values.map do |v|
            raw_value = v["value"]

            value = case raw_value
                    when nil, "", "-999999", "Ice", "Eqp", "Fld", "Bkw", "Rat"
                      nil
                    else
                      raw_value.to_f
                    end

            # For DV: "2025-12-04T00:00:00.000" → "2025-12-04"
            # For IV: "2025-12-04T12:15:00.000-07:00" → full string (preserved)
            datetime = v["dateTime"]
            datetime = datetime[0..9] if datetime&.include?("T00:00:00.000")

            {
              site_no: site_no,
              parameter_cd: parameter_cd,
              datetime: datetime,
              value: value,
              qualifiers: v["qualifiers"],
              unit: unit,
              metadata: {}
            }
          end
        end
      end
    end
  end
end
