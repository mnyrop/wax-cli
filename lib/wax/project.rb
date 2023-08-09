# frozen_string_literal: true

require 'dry-configurable'

module Wax
  class Project
    include Dry::Configurable

    attr_reader :collections

    setting :url,             reader: true
    setting :source,          reader: true
    setting :data_dir,        reader: true
    setting :collections_dir, reader: true
    setting :search_dir,      reader: true
    setting :derivatives_dir, reader: true

    def initialize(opts = {})
      @opts        = Utils.read_hash(opts).to_h
      @collections = []

      load_configuration
      load_collections
    end

    # rubocop:disable Metrics/AbcSize
    def load_configuration
      config.url              = Utils.safe_join @opts.fetch('url', ''), @opts.fetch('baseurl', '')
      config.source           = @opts.fetch 'source', ''
      config.data_dir         = Utils.safe_join config.source, @opts.fetch('data_dir', '_data')
      config.collections_dir  = Utils.safe_join config.source, @opts.fetch('collections_dir', '')
      config.search_dir       = Utils.safe_join config.source, @opts.fetch('search_dir', 'wax/search')
      config.derivatives_dir  = Utils.safe_join config.source, @opts.fetch('derivatives_dir', 'wax/derivatives')
    end
    # rubocop:enable Metrics/AbcSize

    def load_collections
      @collections = @opts.fetch('collections')&.map { |name, opts| Collection.new name, opts, config }
    end

    def find_collection(name)
      @collections.find { |collection| collection.name == name }
    end
  end
end
