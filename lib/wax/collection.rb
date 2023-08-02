# frozen_string_literal: true

require 'ostruct'

require_relative 'buildable'
require_relative 'configurable'

module Wax
  class Collection
    include Buildable
    include Configurable

    attr_reader :name, :config, :build_strategies, :data

    def initialize(name, wax_config)
      @name               = name
      @wax_config         = load wax_config
      @config             = collection_config
      @build_strategies   = infer_build_strategies || []
      @data               = OpenStruct.new
    end

    def collection_config
      raise Wax::ConfigError, "Couldn't find collection '#{name}'. Check your config file?" unless @wax_config['collections'].key? name

      default_config.dup.merge @wax_config.dig 'collections', name
    end

    def default_config
      {
        'data' => {
          'records' => File.join(data_dir, 'records.csv'),
          'assets' => File.join(data_dir, 'assets'),
          'dictionary' => File.join(data_dir, 'dictionary.yml'),
          'items' => File.join(data_dir, 'wax.json')
        },
        'build' => {}
      }
    end

    def data_dir
      File.join @wax_config['data_dir'], 'collections', name
    end

    def records_file
      config.dig 'data', 'records'
    end

    def assets_dir
      config.dig 'data', 'assets'
    end

    def dictionary_file
      config.dig 'data', 'dictionary'
    end

    def build(strategy)
      case strategy
      when 'pages'
        puts 'building pages!! todo'
        # load_dictionary!
        # load_records!
        # build = PagesBuilder.new(self, cache).build
        # puts JSON.pretty_generate build.results
        # data.records = RecordsLoader.new(self).records
        # data.records.to_s
      when 'iiif'
        puts 'building iiif derivatives!! todo'
      when 'simple_images'
        puts 'building simple image derivatives!! todo'
      end
    end

    def build_all
      reorder_strategies!
      @build_strategies.each { |strategy| build strategy }
    end
  end
end
