# frozen_string_literal: true

module Wax
  module Lint
    def self.collection(collection)
      Wax::Lint.cached_items  collection
      Wax::Lint.dictionary    collection
      Wax::Lint.records       collection
    end

    def self.report_results(issues)
      if issues.zero?
        puts Rainbow("\t✓ Looking good!").green
      else
        puts Rainbow("\t✗ Wax found #{issues} or more issues!").orange
      end
    end

    def self.check_file_exists(path, required: false)
      wrkpath = Utils::Path.working path
      if File.file? Utils::Path.absolute(path)
        print Utils::Print.checkmark, "Found file at #{wrkpath}\n"
        true
      else
        print Utils::Print.warning, Rainbow("Didn't find file!! Expected it at #{wrkpath}\n").magenta if required
        puts Rainbow("\t~ Didn't find file #{wrkpath}; Skipping!").tan unless required
        false
      end
    end

    def self.assert_hash(data)
      if data.is_a? Hash
        print Utils::Print.checkmark, "It parses into a valid hash map\n"
        true
      else
        print Utils::Print.warning, Rainbow("\tIt's not a valid hash map!! Instead found type #{data.class}\n").magenta
        false
      end
    end

    def self.assert_hash_array(data)
      if data.is_a?(Array) && data.first.is_a?(Hash)
        print Utils::Print.checkmark, "It parses into an array of hashes\n"
        true
      else
        type = data.is_a?(Array) ? data.first.class : data.class
        print Utils::Print.warning,
              Rainbow("It does not parse into an array of hashes! Instead found #{type}\n").magenta
        false
      end
    end

    def self.assert_ext_opts(file, opts)
      ext = File.extname(file).downcase
      if opts.include? ext
        print Utils::Print.checkmark, "It has valid file extension #{ext}\n"
        true
      else
        print Utils::Print.warning, Rainbow("It has unexpected file extension #{ext}!! Expected #{opts}\n").magenta
        false
      end
    end

    def self.assert_ext_match(file, pattern)
      ext = File.extname(file).downcase
      if ext.match pattern
        print Utils::Print.checkmark, "It has valid file extension #{ext}\n"
        true
      else
        puts Utils::Print.warning, Rainbow("It has unexpected file extension #{ext}!! Expected #{pattern}\n")
        false
      end
    end

    def self.cached_items(collection)
      puts Rainbow("Linting #{collection.name} wax-generated json...").cyan
      issues  = 0
      file    = Utils::Path.absolute collection.config.wax_json_file

      return unless check_file_exists file

      issues += 1 unless assert_ext_opts file, ['.json']
      data = Utils::Read.json file
      issues += 1 unless assert_hash data

      if Utils.all_items? collection.cached_items
        print Utils::Print.checkmark,
              "It loads #{collection.cached_items.size} cached items\n"
      end
      report_results issues
    end

    def self.dictionary(collection)
      puts Rainbow("Linting #{collection.name} dictionary...").cyan
      issues  = 0
      file    = Utils::Path.absolute collection.config.dictionary_file

      return unless check_file_exists file

      issues += 1 unless assert_ext_match file, /\.ya?ml/
      data = Wax::Utils::Read.yaml file
      issues += 1 unless assert_hash data
      report_results issues
    end

    def self.records(collection)
      puts Rainbow("Linting #{collection.name} records...").cyan
      issues  = 0
      file    = Utils::Path.absolute collection.config.records_file

      return unless check_file_exists(file, required: true)

      issues += 1 unless assert_ext_opts file, ['.csv', '.json', /\.ya?ml/]
      data = Utils::Read.records_file file
      issues += 1 unless assert_hash_array data
      issues += 1 unless assert_existing_pids data
      issues += 1 unless assert_unique_pids data

      report_results issues
    end

    def self.assert_existing_pids(records)
      missing = missing_pids records
      if missing.any?
        print Utils::Print.warning, Rainbow("Not all records have 'pid' values!!!\n").magenta,
              Rainbow("\t\tCulprits (by index): #{missing}\n").salmon
        false
      else
        print Utils::Print.checkmark, "All records have 'pid' values\n"
        true
      end
    end

    def self.assert_unique_pids(records)
      duplicates = duplicate_pids records
      if duplicates.any?
        print Utils::Print.warning, Rainbow("Some records have duplicate pid values!!!\n").magenta,
              Rainbow("\t\tCulprits (by pid): #{duplicates}\n").salmon
        false
      else
        print Utils::Print.checkmark, "All 'pid' values are unique\n"
        true
      end
    end

    def self.missing_pids(records)
      missing = records.find_all { |record| record['pid'].to_s.empty? }
      missing.map { |record| records.find_index record }
    end

    def self.duplicate_pids(records)
      pids = records.map { |record| record['pid'] }.compact
      pids.find_all { |pid| pids.count(pid) > 1 }.uniq
    end
  end
end
