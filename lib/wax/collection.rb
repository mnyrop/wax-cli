# frozen_string_literal: true

require 'dry-configurable'

require_relative 'build_strategies'

module Wax
  class Collection
    include BuildStrategies
    include Dry::Configurable

    attr_reader :name, :build_strategies

    setting :name,            reader: true
    setting :source_dir,      reader: true
    setting :data_dir,        reader: true
    setting :records_file,    reader: true
    setting :assets_dir,      reader: true
    setting :dictionary_file, reader: true
    setting :wax_json_file,   reader: true
    setting :derivatives_dir, reader: true
    setting :pages_dir,       reader: true
    setting :build_opts,      reader: true
    setting :site_url,        reader: true

    def initialize(name, opts, project)
      @name             = name
      @opts             = opts
      @project          = project
      @build_strategies = infer_build_strategies

      load_configuration
    end

    # rubocop:disable Metrics/AbcSize
    def load_configuration
      config.name             = @name
      config.source_dir       = @project.source
      config.data_dir         = Utils::Path.safe_join @project.data_dir, 'collections', @name
      config.records_file     = Utils::Path.safe_join(config.data_dir, @opts.dig('data', 'records') || 'records.csv')
      config.assets_dir       = Utils::Path.safe_join(config.data_dir, @opts.dig('data', 'assets')  || 'assets')
      config.dictionary_file  = Utils::Path.safe_join(config.data_dir,
                                                      @opts.dig('data', 'dictionary') || 'dictionary.yml')
      config.wax_json_file    = Utils::Path.safe_join(config.data_dir, 'wax.json')
      config.derivatives_dir  = Utils::Path.safe_join(@project.derivatives_dir, @name)
      config.pages_dir        = Utils::Path.safe_join(@project.collections_dir, "_#{@name}")
      config.build_opts       = @opts.fetch 'build', {}
      config.site_url         = @project.url
    end
    # rubocop:enable Metrics/AbcSize

    def dictionary
      @dictionary ||= Wax::Parsers::Dictionary.parse config.dictionary_file
    end

    def records
      @records ||= Wax::Parsers::Records.parse config.records_file, dictionary
    end

    def asset_map
      @asset_map ||= Wax::Parsers::AssetMap.parse config.assets_dir
    end

    def cached_items
      @cached_items ||= Wax::Parsers::Items.parse_cached_json(records, asset_map, config.wax_json_file)
    end

    def items
      @items ||= cached_items || Wax::Parsers::Items.parse(records, asset_map)
    end

    def build(list = build_strategies)
      strategies = BuildStrategies.validate list
      warn Rainbow("Warning!! Tried running #build on collection #{name} but no valid build strategies were provided.").orange, "Culprit: #{list}" and return unless strategies.any?

      strategies.each do |strategy|
        opts    = strategy_opts strategy
        builder = Factory.new(strategy, config, opts).builder
        @items  = builder.build items
      end
    end

    def clear_cached_items
      puts Rainbow('Clobbering wax-generated json...').cyan
      print Utils::Print.checkmark, "Clearing out #{Utils::Path.working config.wax_json_file}\n"
      FileUtils.rm_f Utils::Path.absolute(config.wax_json_file)
      @cached_items = nil
      print Utils::Print.checkmark, Rainbow("Done!\n").green
    end

    def clear_items
      @items = nil
    end

    def clobber(list: build_strategies, force: false)
      clear_cached_items and clear_items if force
      strategies = BuildStrategies.validate list

      warn Rainbow("Warning!! Tried running #clobber on collection #{name} but no valid build strategies were provided.").orange, "Culprit: #{list}" and return unless strategies.any?

      strategies.each do |strategy|
        opts    = strategy_opts strategy
        builder = Factory.new(strategy, config, opts).builder
        builder.clobber items, force:
      end
    end
  end
end
