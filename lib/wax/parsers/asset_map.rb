# frozen_string_literal: true

module Wax
  module Parsers
    module AssetMap
      def self.parse(dir)
        root_path = Utils::Path.absolute dir
        warn Rainbow("Warning!! Tried to load assets for collection #{name} from #{root_path} but that directory does not exist.").orange and return [] unless File.directory? root_path

        Wax::Utils::Image.split_all_pdfs root_path

        asset_map = {}
        paths = Dir.glob("#{root_path}/*[!.pdf]")
        paths.each { |path| asset_map[pid(path)] = asset_list(path) }
        asset_map
      end

      def self.pid(path)
        File.basename path, File.extname(path)
      end

      def self.asset_list(path)
        child_paths = Utils::Image.file_type(path) == 'dir' ? Dir.glob(File.join(path, '*')) : [path]
        {}.tap do |hash|
          child_paths.each_with_index { |child, index| hash[index] = Utils::Path.working child }
        end
      end
    end
  end
end
