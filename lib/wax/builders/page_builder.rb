# frozen_string_literal: true

require 'yaml'

require_relative '../builder'

module Wax
  class PageBuilder < Builder
    def page_dir = Utils::Path.absolute collection_config.pages_dir

    def build(items)
      @items = items
      puts Rainbow('Building pages.').cyan
      @items.each { |item| write_page item }
      puts Rainbow("Done ✓\n").green
      @items
    end

    def write_page(item)
      FileUtils.mkdir_p page_dir unless File.directory? page_dir

      file = File.join(page_dir, "#{item.pid}.md")
      File.write file, item.to_page_yaml
    end

    def clobber(_items, _force)
      puts Rainbow("Clobbering pages in #{Utils::Path.working page_dir}").cyan
      FileUtils.rm_rf page_dir
      puts Rainbow("Done ✓\n").green
    end
  end
end
