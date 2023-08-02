# frozen_string_literal: true

require_relative 'configurable'

module Wax
  class Project
    include Configurable

    attr_reader :wax_config, :collections

    def initialize(config)
      @custom       = load config
      @wax_config   = waxed_config
      @collections  = []
    end

    def waxed_config
      conf = default_config.dup.merge @custom.dup
      %w[collections_dir data_dir search_dir].each do |key|
        conf[key] = File.join conf['source'], conf[key]
      end
      conf['url'] = File.join conf['url'], conf['baseurl']
      conf.delete 'baseurl'
      conf
    end

    def default_config
      {
        'url' => '',
        'baseurl' => '',
        'source' => '',
        'collections_dir' => '',
        'data_dir' => '_data',
        'search_dir' => 'search',
        'collections' => {}
      }
    end

    def load_collection(name)
      if collections.empty?
        collection = Collection.new name, @wax_config
        collections << collection
        collection
      else
        puts 'looking in .collections'
        # look for a collection in @collections with the right name
      end
    end
  end
end
