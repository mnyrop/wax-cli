# frozen_string_literal: true

module Wax
  module Parsers
    module Records
      def self.parse(file, dictionary)
        path    = Utils::Path.absolute(file)
        records = File.file?(path) ? Utils::Read.records_file(path) : []
        records = apply_transformations(records, dictionary)

        raise Wax::CollectionError, "One or more records in #{file} are missing a 'pid' field. Try linting, then add required pids and rerun." if Wax::Lint.missing_pids(records).any?
        raise Wax::CollectionError, "One or more records in #{file} have a duplicate 'pid' field. Try linting, ensure pids are unique and rerun." if Wax::Lint.duplicate_pids(records).any?

        records
      end

      def self.apply_transformations(records, dictionary)
        records = infer_order(records)
        split_array_fields(records, dictionary)
      end

      def self.infer_order(records)
        records.map.each_with_index do |record, index|
          record['order'] = Utils.padded_int(index, records.size) unless record.key? 'order'
          record
        end
      end

      # :reek:NestedIterators { max_allowed_nesting: 2 }
      def self.split_array_fields(records, dictionary)
        array_fields = dictionary&.find_all { |_key, value| value.key? 'array_split' } || []
        return records unless array_fields.any?

        records.map do |record|
          array_fields.each do |key, value|
            next unless record.key? key

            record[key] = record[key].split(value['array_split'].strip)
          end
          record
        end
      end
    end
  end
end
