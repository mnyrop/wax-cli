# frozen_string_literal: true

module Wax
  module Parsers
    module Records
      def self.parse(file, dictionary)
        path    = Utils::Path.absolute(file)
        records = File.file?(path) ? Utils::Read.records_file(path) : []
        validate_pids(apply_transformations(records, dictionary))
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

      def self.validate_pids(records)
        assert_unique_pids(assert_pid_value(records))
      end

      def self.assert_pid_value(records)
        no_pids = records.find_all  { |record| record['pid'].to_s.empty? }
        raise Wax::CollectionError, "One or more records in #{config.records_file} are missing a 'pid' field. Add required pids and rerun.", "Culprits: #{no_pids}" if no_pids.any?

        records
      end

      def self.assert_unique_pids(records)
        pids        = records.map       { |record| record['pid'] }.compact
        duplicates  = pids.find_all     { |pid| pids.count(pid) > 1 }.uniq
        raise Wax::CollectionError, "One or more records in #{config.records_file} have a duplicate 'pid' field. Ensure pids are unique and rerun.", "Culprits: #{duplicates}" if duplicates.any?

        records
      end

      # :reek:NestedIterators { max_allowed_nesting: 2 }
      def self.split_array_fields(records, dictionary)
        array_fields = dictionary.find_all { |_key, value| value.key? 'array_split' }
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
