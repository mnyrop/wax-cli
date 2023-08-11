# frozen_string_literal: true

require_relative '../builder'

module Wax
  class PageBuilder < Builder
    def build(items)
      @items = items
      puts 'Building pages!'
      update_json
      @items
    end

    def clobber(_items)
      puts Rainbow('Clobbering pages.').cyan
      update_json
    end
  end
end
