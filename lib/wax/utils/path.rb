# frozen_string_literal: true

module Wax
  module Utils
    module Path
      def self.working_dir = ENV['WORKING_DIR'] || Dir.pwd

      def self.absolute(path)
        return path if path.start_with? working_dir

        File.join working_dir, path
      end

      def self.working(path)
        return path unless path.start_with? working_dir

        path.sub(working_dir, '').reverse.chomp('/').reverse
      end

      def self.safe_join(*paths)
        File.join(*paths).reverse.chomp('/').reverse.chomp('/')
      end

      def self.basename(file)
        File.basename file, File.extname(file)
      end
    end
  end
end
