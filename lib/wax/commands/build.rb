# frozen_string_literal: true

require_relative 'base'

module Wax
  module Commands
    class Build < Base
      class_option :config,         type: :string,  default: './_config.yml', desc: 'Path to yaml config file'
      class_option :iiif,           type: :boolean, desc: 'If true, builds IIIF resources.'
      class_option :pages,          type: :boolean, desc: 'If true, builds markdown page for each item.'
      class_option :simple_images,  type: :boolean, desc: 'If true, builds simple image derivatives.'

      desc 'collection NAME', 'Build the wax collection named NAME'
      def collection(name)
        Wax::BuildStrategies.validate options.keys
        project    = Wax::Project.new options['config']
        collection = project.find_collection name

        raise Wax::CollectionError, "No collection found with name '#{name}'. Check your config?" unless collection.is_a? Wax::Collection

        collection.assets
        # collection.overwrite_build_strategies build_opts if build_opts.any?
        # collection.build
      end

      desc 'collections', 'Build all available wax collections'
      def collections
        puts "building all the collections with options #{options}"
      end

      desc 'item COLLECTION_NAME ITEM_ID', 'Build the item with id ITEM_ID in wax collection named COLLECTION_NAME'
      def item(name, id)
        puts "building item '#{id}' within collection #{name}' with options #{options}"
      end
    end
  end
end
