# frozen_string_literal: true

require_relative 'build_strategies'

module Wax
  # Abstract Class
  class Builder
    attr_reader :collection_config, :opts, :items

    def initialize(collection_config, opts = {})
      @collection_config  = collection_config
      @opts               = Hash.new opts
      @items              = []

      load_configuration
      validate
    end

    def build
      raise Wax::Error, 'Called method #build on abstract class Builder. Perhaps you meant to create a PageBuilder, IIIFBuilder, or SimpleImageBuilder?'
    end

    def clobber
      raise Wax::Error, 'Called method #clobber on abstract class Builder. Perhaps you meant to create a PageBuilder, IIIFBuilder, or SimpleImageBuilder?'
    end

    def load_configuration; end
    def validate; end

    def update_wax_json
      merged = load_wax_json.merge items_hash
      print Utils::Print.checkmark, "Updating #{collection_config.wax_json_file}\n"
      File.write Utils::Path.absolute(collection_config.wax_json_file), JSON.pretty_generate(merged)
    end

    def load_wax_json
      file = Utils::Path.absolute collection_config.wax_json_file
      File.file?(file) ? Utils::Read.json(file) : {}
    end

    def overwrite_wax_json
      print Utils::Print.checkmark, "Overwriting #{collection_config.wax_json_file}\n"
      file = Utils::Path.absolute collection_config.wax_json_file
      File.write file, items_json
    end

    def items_json
      JSON.pretty_generate items_hash
    end

    def items_hash
      {}.tap do |hash|
        @items.map(&:compact_hash).each { |item| hash[item['pid']] = item }
      end
    end

    def prune_source(path)
      source = collection_config.source_dir
      path.gsub!(/\A#{Regexp.quote(source)}/, '') unless source.to_s.empty?
      path
    end
  end
end
