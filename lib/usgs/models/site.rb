# frozen_string_literal: true

module Usgs
  module Models
    # Represents a USGS monitoring site/station
    #
    # @!attribute [rw] agency_cd
    #   @return [String] Agency code
    # @!attribute [rw] site_no
    #   @return [String] USGS site number
    # @!attribute [rw] station_nm
    #   @return [String] Station name
    # @!attribute [rw] site_tp_cd
    #   @return [String] Site type code
    # @!attribute [rw] dec_lat_va
    #   @return [Float, nil] Decimal latitude
    # @!attribute [rw] dec_long_va
    #   @return [Float, nil] Decimal longitude
    # @!attribute [rw] coord_acy_cd
    #   @return [String] Coordinate accuracy code
    # @!attribute [rw] dec_coord_datum_cd
    #   @return [String] Decimal coordinate datum code
    # @!attribute [rw] alt_va
    #   @return [String] Altitude value
    # @!attribute [rw] alt_acy_va
    #   @return [String] Altitude accuracy value
    # @!attribute [rw] alt_datum_cd
    #   @return [String] Altitude datum code
    # @!attribute [rw] huc_cd
    #   @return [String] Hydrologic unit code
    # @!attribute [rw] metadata
    #   @return [Hash] Additional metadata
    class Site
      ATTRIBUTES = %i[
        agency_cd
        site_no
        station_nm
        site_tp_cd
        dec_lat_va
        dec_long_va
        coord_acy_cd
        dec_coord_datum_cd
        alt_va
        alt_acy_va
        alt_datum_cd
        huc_cd
        metadata
      ].freeze

      attr_accessor(*ATTRIBUTES) # :nodoc:

      def initialize(attrs = {})
        attrs = attrs.is_a?(Hash) ? attrs : {}
        attrs[:metadata] ||= {}
        ATTRIBUTES.each do |attr|
          instance_variable_set(:"@#{attr}", attrs[attr]) if attrs.key?(attr)
        end
      end
    end
  end
end
