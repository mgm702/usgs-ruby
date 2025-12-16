# frozen_string_literal: true

module Usgs
  module Models
    # Represents a USGS statistic record
    #
    # @!attribute [rw] site_no
    #   @return [String] USGS site number
    # @!attribute [rw] parameter_cd
    #   @return [String] Parameter code
    # @!attribute [rw] month_nu
    #   @return [Float, nil] Month number
    # @!attribute [rw] day_nu
    #   @return [Float, nil] Day number
    # @!attribute [rw] begin_yr
    #   @return [Float, nil] Beginning year
    # @!attribute [rw] end_yr
    #   @return [Float, nil] Ending year
    # @!attribute [rw] count_nu
    #   @return [Float, nil] Count of values
    # @!attribute [rw] mean_va
    #   @return [Float, nil] Mean value
    # @!attribute [rw] max_va
    #   @return [Float, nil] Maximum value
    # @!attribute [rw] max_va_yr
    #   @return [Float, nil] Year of maximum value
    # @!attribute [rw] min_va
    #   @return [Float, nil] Minimum value
    # @!attribute [rw] min_va_yr
    #   @return [Float, nil] Year of minimum value
    # @!attribute [rw] p05_va
    #   @return [Float, nil] 5th percentile value
    # @!attribute [rw] p10_va
    #   @return [Float, nil] 10th percentile value
    # @!attribute [rw] p20_va
    #   @return [Float, nil] 20th percentile value
    # @!attribute [rw] p25_va
    #   @return [Float, nil] 25th percentile value
    # @!attribute [rw] p50_va
    #   @return [Float, nil] 50th percentile (median) value
    # @!attribute [rw] p75_va
    #   @return [Float, nil] 75th percentile value
    # @!attribute [rw] p80_va
    #   @return [Float, nil] 80th percentile value
    # @!attribute [rw] p90_va
    #   @return [Float, nil] 90th percentile value
    # @!attribute [rw] p95_va
    #   @return [Float, nil] 95th percentile value
    # @!attribute [rw] metadata
    #   @return [Hash] Additional metadata
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

      attr_accessor(*ATTRIBUTES) # :nodoc:

      def initialize(data = {})
        data[:metadata] ||= {}
        attrs = data.is_a?(Hash) ? data : {}
        ATTRIBUTES.each do |attr|
          value = attrs[attr]

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
