# frozen_string_literal: true

require_relative '../builder'

module Wax
  class IIIFBuilder < Builder
    def build(items)
      @items = items
      puts 'Building IIIF resources...'
      update_wax_json
      @items
    end

    def clobber(_items)
      puts Rainbow('Clobbering IIIF derivatives...').cyan
      update_wax_json
    end
  end
end
