# frozen_string_literal: true

module Usgs
  module Parsers
    module InstantaneousValuesParser
      class << self
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
                    when nil, "", "-999999", "Ice", "Eqp", "Fld"
                      nil
                    else
                      raw_value.to_f
                    end

            {
              site_no:      site_no,
              parameter_cd: parameter_cd,
              datetime:     v["dateTime"],
              value:        value,
              qualifiers:   v["qualifiers"],
              unit:         unit,
              metadata:     {}
            }
          end
        end
      end
    end
  end
end
