# frozen_string_literal: true

module Usgs
  module Parsers
    module RdbParser
      class << self
        # Parse any USGS RDB response (format=rdb or rdb,1.0)
        #
        # @param text [String] Raw RDB text
        # @return [Array<Hash>] Rows with symbolized column names
        def parse(text)
          lines = text.lines.map(&:rstrip)

          # Drop all comment lines (#)
          data_lines = lines.drop_while { |l| l.start_with?("#") }

          return [] if data_lines.empty?

          field_names_line = data_lines[0]

          data_start_index = if data_lines[1]&.match?(/\A(\d+[sd])\t/)
                               2
                             else
                               1
                             end

          column_names = field_names_line.split("\t")
          data_lines[data_start_index..].map do |line|
            next if line.empty? || line.start_with?("#")
            values = line.split("\t")
            Hash[column_names.zip(values)].transform_keys { |k| k.strip.to_sym }
          end.compact
        end

        # For time series (iv, dv, etc.)
        def parse_time_series(text)
          rows = parse(text)
          rows.map do |row|
            value = row[:value]&.strip
            value = nil if value.nil? || value == "" || value == "-999999" || value.downcase.include?("ice")

            {
              site_no:     row[:site_no]&.strip,
              datetime:    row[:datetime] || row[:dateTime],
              value:       value&.to_f,
              code:        row[:value_cd] || row[:qualifiers],
              parameter_cd: row[:parameter_cd] || row[:parm_cd]
            }.compact
          end
        end
      end
    end
  end
end
