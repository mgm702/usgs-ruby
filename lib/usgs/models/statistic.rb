# frozen_string_literal: true

module Usgs
  module Models
    class Statistic
      ATTRIBUTES = %i[
        site_no
        parameter_cd
        month_nu
        day_nu
        begin_yr
        end_yr
        count_nu
        mean_va
        max_va
        max_va_yr
        min_va
        min_va_yr
        p05_va
        p10_va
        p20_va
        p25_va
        p50_va
        p75_va
        p80_va
        p90_va
        p95_va
        metadata
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def initialize(data = {})
        data[:metadata] ||= {}
        attrs = data.is_a?(Hash) ? data : {}

        ATTRIBUTES.each do |attr|
          value = attrs[attr]

          # Convert all the _va fields (values) from string to float
          if value.is_a?(String) && attr.to_s.end_with?("_va", "_yr", "_nu")
            stripped = value.strip
            value = stripped.empty? || stripped == "." ? nil : stripped.to_f
          end

          instance_variable_set(:"@#{attr}", value) if attrs.key?(attr)
        end
      end
    end
  end
end
