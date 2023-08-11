# frozen_string_literal: true

require 'yaml'

require_relative '../builder'

module Wax
  class PageBuilder < Builder
    include Dry::Configurable

    setting :page_dir,  reader: true
    setting :layout,    reader: true

    def load_configuration
      config.page_dir = Utils::Path.absolute collection_config.pages_dir
      config.layout   = @opts.fetch 'layout', 'item'
    end

    def build(items)
      @items = items
      puts Rainbow('Building pages.').cyan
      @items.each { |item| write_page item }
      puts Rainbow("Done ✓\n").green
      @items
    end

    def write_page(item)
      FileUtils.mkdir_p config.page_dir unless File.directory? config.page_dir

      file = File.join(config.page_dir, "#{item.pid}.md")
      File.write file, "#{page_hash(item).to_yaml}---\n"
    end

    def page_hash(item)
      page_hash = item.to_h.except('assets')
      page_hash['layout'] = config.layout if config.layout
      Utils.compact_hash page_hash
    end

    def clobber(_items, _force)
      puts Rainbow("Clobbering pages in #{Utils::Path.working config.page_dir}").cyan
      FileUtils.rm_rf config.page_dir
      puts Rainbow("Done ✓\n").green
    end
  end
end
