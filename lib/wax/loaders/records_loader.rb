# frozen_string_literal: true

require 'ostruct'

module Wax
  class RecordsLoader
    attr_reader :collection

    Record = OpenStruct

    def initialize(collection)
      @collection = collection
      @file       = collection.records_file
      @records    = records
    end

    # find records file && assert file exists
    # check if file has changed since last read
    # if not:
    #    use existing collection.data.records in memory if exists
    #    read in wax.json file as array of hashes and map to Record objects
    # if so:
    #    read in the records file w/ error handling for type as array of hashes
    #    map to Record objects
    def records
      hashes = validate_hashes read_file(@file)
      # hashes = dictionary.transform(hashes) if dictionary?
      hashes.map { |hash| Record.new hash }
    end

    def read_file(file)
      path = Wax::Utils.absolute_path file
      raise Wax::FileNotFoundError unless File.file? path

      case File.extname path
      when '.csv'
        Wax::Utils.read_csv path
      when '.json'
        Wax::Utils.read_json path
      when /\.ya?ml/
        Wax::Utils.read_yaml path
      else
        raise Wax::InvalidFileError, ''
      end
    end

    def validate_hashes(raw)
      # assert array of hashes
      # assert unique pids
      # assert no banned fields (e.g., _date, id)
      raw
    end

    # looks for collection.data.dictionary if exists in memory
    # tries to load from dictionary file
    # validates dictionary
    # null
    # This method smells of :reek:DuplicateMethodCall
    def dictionary
      return collection.data.dictionary if collection.data.dictionary.is_a? Hash

      file = Wax::Utils.absolute_path collection.records_file
      return nil unless File.file? file

      dict = Wax::Utils.read_yaml file
      collection.data.dictionary = dict
      dict
    end

    # clearer bool of dictionary valid existence
    def dictionary?
      !!dictionary
    end
  end
end
