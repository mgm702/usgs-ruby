# frozen_string_literal: true

module Usgs
  module Parsers
    module StatisticsParser
      class << self
        def parse(rdb_text)
          rows = Parsers::RdbParser.parse(rdb_text)

          rows.map do |row|
            {
              site_no: row[:site_no]&.strip,
              parameter_cd: row[:parameter_cd]&.strip,
              month_nu: row[:month_nu]&.to_i,
              day_nu: row[:day_nu]&.to_i,
              begin_yr: row[:begin_yr]&.to_i,
              end_yr: row[:end_yr]&.to_i,
              count_nu: row[:count_nu]&.to_i,
              mean_va: row[:mean_va],
              max_va: row[:max_va],
              max_va_yr: row[:max_va_yr]&.to_i,
              min_va: row[:min_va],
              min_va_yr: row[:min_va_yr]&.to_i,
              p05_va: row[:p05_va],
              p10_va: row[:p10_va],
              p20_va: row[:p20_va],
              p25_va: row[:p25_va],
              p50_va: row[:p50_va],
              p75_va: row[:p75_va],
              p80_va: row[:p80_va],
              p90_va: row[:p90_va],
              p95_va: row[:p95_va],
              metadata: {}
            }
          end
        end
      end
    end
  end
end
