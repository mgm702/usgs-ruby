# frozen_string_literal: true

module Usgs
  module Models
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

      attr_accessor(*ATTRIBUTES)

      def initialize(attrs = {})
        # Accept either a single hash OR keyword arguments
        attrs = attrs.is_a?(Hash) ? attrs : {}
        attrs[:metadata] ||= {}

        ATTRIBUTES.each do |attr|
          instance_variable_set(:"@#{attr}", attrs[attr]) if attrs.key?(attr)
        end
      end
    end
  end
end
