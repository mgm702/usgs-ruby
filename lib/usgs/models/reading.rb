# frozen_string_literal: true

module Usgs
  module Models
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

      attr_accessor(*ATTRIBUTES)

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
