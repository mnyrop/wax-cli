# frozen_string_literal: true

require 'dry-configurable'

require_relative 'build_strategies'
require_relative 'loaders/dictionary_loader'
require_relative 'loaders/records_loader'
require_relative 'loaders/assets_loader'
require_relative 'loaders/items_loader'

module Wax
  class Collection
    include BuildStrategies
    include Dry::Configurable

    attr_reader :name

    setting :data_dir,        reader: true
    setting :records_file,    reader: true
    setting :assets_dir,      reader: true
    setting :dictionary_file, reader: true
    setting :derivatives_dir, reader: true
    setting :pages_dir,       reader: true

    def initialize(name, opts, project)
      @name             = name
      @opts             = opts
      @project          = project

      load_configuration
    end

    # rubocop:disable Metrics/AbcSize
    def load_configuration
      config.data_dir         = Utils.safe_join @project.data_dir, 'collections', @name
      config.records_file     = Utils.safe_join(config.data_dir, @opts.dig('data', 'records') || 'records.csv')
      config.assets_dir       = Utils.safe_join(config.data_dir, @opts.dig('data', 'assets')  || 'assets')
      config.dictionary_file  = Utils.safe_join(config.data_dir, @opts.dig('data', 'dictionary') || 'dictionary.yml')
      config.derivatives_dir  = Utils.safe_join(@project.derivatives_dir, @name)
      config.pages_dir        = Utils.safe_join(@project.collections_dir, "_#{@name}")
    end
    # rubocop:enable Metrics/AbcSize

    def dictionary
      @dictionary ||= Wax::DictionaryLoader.load config.dictionary_file
    end

    def records
      @records ||= Wax::RecordsLoader.load config.records_file, dictionary
    end

    def assets
      @assets ||= Wax::AssetsLoader.load config.assets_dir
    end

    def items
      @items ||= Wax::ItemsLoader.load records, assets
    end

    def load_data
      dictionary
      records
      assets
      items
    end
  end
end
