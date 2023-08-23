# frozen_string_literal: true

require 'json'

module Wax
  module Parsers
    module Items
      def self.parse(records, asset_map)
        records.map.with_index do |record, index|
          pid       = record.fetch 'pid'
          label     = record.fetch 'label', 'pid'
          order     = record.fetch 'order', Utils.padded_int(index, records.size)
          metadata  = record.except 'pid', 'label', 'order'
          assets    = asset_map[pid] || {}
          opts      = { 'label' => label, 'order' => order, 'metadata' => metadata, 'assets' => assets }

          Wax::Item.new pid, opts
        end
      end

      def self.parse_cached_json(records, asset_map, wax_json_file)
        file = Utils::Path.absolute wax_json_file
        return unless File.file? file

        hash = Utils::Read.json file
        hash.map do |_k, value|
          pid             = value.fetch('pid')
          record          = records.find { |rec| rec['pid'] == pid } || {}
          value['assets'] = asset_map[pid]

          value.merge! record
          Wax::Item.new pid, value
        end
      end
    end
  end
end
