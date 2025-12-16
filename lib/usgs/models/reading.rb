# frozen_string_literal: true

module Usgs
  module Models
    # Represents a USGS reading/measurement
    #
    # @!attribute [rw] site_no
    #   @return [String] USGS site number
    # @!attribute [rw] parameter_cd
    #   @return [String] Parameter code
    # @!attribute [rw] datetime
    #   @return [String] Date and time of reading
    # @!attribute [rw] value
    #   @return [Float, nil] Measured value
    # @!attribute [rw] qualifiers
    #   @return [Array<String>] Quality/approval codes
    # @!attribute [rw] unit
    #   @return [String] Unit of measurement
    # @!attribute [rw] metadata
    #   @return [Hash] Additional metadata
    class Reading
      ATTRIBUTES = %i[
        site_no
        parameter_cd
        datetime
        value
        qualifiers
        unit
        metadata
      ].freeze

      attr_accessor(*ATTRIBUTES) # :nodoc:

      def initialize(data = {})
        data[:metadata] ||= {}
        attrs = data.is_a?(Hash) ? data : {}
        ATTRIBUTES.each do |attr|
          instance_variable_set(:"@#{attr}", attrs[attr]) if attrs.key?(attr)
        end
      end
    end
  end
end
