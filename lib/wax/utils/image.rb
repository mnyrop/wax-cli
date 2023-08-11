# frozen_string_literal: true

begin
  require 'vips'
rescue LoadError
  raise Wax::DependencyError, "Wax now uses Libvips to create derivatives instead of ImageMagick!\nPlease install Libvips using the instructions at https://libvips.github.io/libvips/install.html.\n\n"
end

require 'pdf-reader'
require 'ruby-progressbar'

module Wax
  module Utils
    module Image
      def self.split_all_pdfs(dir)
        pdf_files = Dir.glob("#{dir}/*.pdf")
        pdf_files.each { |pdf_file| split_pdf_images pdf_file }
      end

      def self.split_pdf_images(pdf_file)
        target_dir = pdf_file.gsub '.pdf', ''
        return unless Dir.glob("#{target_dir}/*").empty?

        FileUtils.mkdir_p target_dir
        page_count = PDF::Reader.new(pdf_file).page_count

        Parallel.each(0..page_count - 1) do |index|
          target  = "#{Utils.padded_int(index, page_count)}.jpg"
          img     = Vips::Image.new_from_file pdf_file, page: index

          img.jpegsave File.join target_dir, target
        end
      end

      def self.new_variant(image, width)
        image.dup.thumbnail_image width, height: 10_000_000
      end

      def self.file_type(path)
        File.directory?(path) ? 'dir' : File.extname(path).downcase.tr('.', '')
      end
    end
  end
end
