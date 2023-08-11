# frozen_string_literal: true

require_relative '../builder'

module Wax
  class IIIFBuilder < Builder
    def build(items)
      @items = items
      puts 'Building IIIF!'
      update_json
      @items
    end

    def clobber(_items)
      puts Rainbow('Clobbering IIIF derivatives.').cyan
      update_json
    end
  end
end
