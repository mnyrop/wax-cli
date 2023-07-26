# frozen_string_literal: true

require_relative 'base'

module Wax
  module Command
    class Build < Base
      class_option :iiif,           type: :boolean, desc: 'If true, builds IIIF resources.'
      class_option :pages,          type: :boolean, desc: 'If true, builds markdown page for each item.'
      class_option :simple_images,  aliases: '--simple', type: :boolean,
                                    desc: 'If true, builds simple image derivatives.'

      desc 'collection NAME', 'Build the wax collection named NAME'
      option :search, type: :boolean, desc: 'If true, builds a search index for the collection.'
      option :reset, type: :boolean, default: false, desc: 'If true, clobbers the collection to reset before running.'
      def collection(name)
        puts "building the '#{name}' collection with options #{options}"
      end

      desc 'collections', 'Build all available wax collections'
      option :search, type: :boolean, desc: 'If true, builds search indexes for each collection.'
      option :reset, type: :boolean, default: false,
                     desc: 'If true, clobbers the collections to reset before running.'
      def collections
        puts "building all the collections with options #{options}"
      end

      desc 'item COLLECTION_NAME ITEM_ID', 'Build the item with id ITEM_ID in wax collection named COLLECTION_NAME'
      option :reset, type: :boolean, default: false, desc: 'If true, prunes the item to reset before running.'
      def item(name, id)
        puts "building item '#{id}' within collection #{name}' with options #{options}"
      end
    end
  end
end
