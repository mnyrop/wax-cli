# frozen_string_literal: true

require_relative 'base'

module Wax
  module Commands
    class Clobber < Base
      class_option :config,         type: :string,  default: './_config.yml', desc: 'Path to yaml config file'
      class_option :iiif,           type: :boolean, desc: 'If true, builds IIIF resources.'
      class_option :pages,          type: :boolean, desc: 'If true, builds markdown page for each item.'
      class_option :simple_images,  type: :boolean, desc: 'If true, builds simple image derivatives.'

      desc 'collection NAME', 'Clobber the wax collection named NAME'
      def collection(name)
        build_opts = Wax::BuildStrategies.validate options.keys
        project    = Wax::Project.new options['config']
        collection = project.find_collection name

        raise Wax::CollectionError, "No collection found with name '#{name}'. Check your config?" unless collection.is_a? Wax::Collection

        collection.overwrite_build_strategies(build_opts) if build_opts.any?
        collection.clobber
      end

      desc 'collections', 'Clobber all available wax collections'
      def collections
        puts 'clobbering all the collections'
      end

      desc 'item COLLECTION_NAME ITEM_ID', 'Clobber the item with ITEM_ID within COLLECTION_NAME collection'
      def item(name, id)
        puts "resetting item #{id} from collection #{name}"
      end
    end
  end
end
