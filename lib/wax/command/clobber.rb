# frozen_string_literal: true

require_relative 'base'

module Wax
  module Command
    class Clobber < Base
      desc 'collection NAME', 'Clobber the wax collection named NAME'
      def collection(name)
        puts "clobbering the '#{name}' collection"
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
