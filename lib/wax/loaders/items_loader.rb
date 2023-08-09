# frozen_string_literal: true

module Wax
  module ItemsLoader
    # :reek:NestedIterators { max_allowed_nesting: 2 }
    def self.load(records, assets)
      records.map do |record|
        paired_asset = assets.find { |asset| asset['pid'] == record['pid'] }
        record['asset'] = { 'type' => paired_asset['type'], 'path' => paired_asset['path'] } if paired_asset
        record
      end
    end
  end
end
