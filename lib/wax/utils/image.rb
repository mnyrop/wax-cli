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
      DEFAULT_MAX = 1400
      
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

      def self.aspect_ratio(width, height)
        width > height ? (width / height) : -(height / width)
      end

      def self.extra_tall?(image)
        aspect_ratio(image.width, image.height) >= 3
      end 

      def self.extra_wide?(image)
        aspect_ratio(image.width, image.height) <= -3
      end

      def self.pick_smallest(*args)
        args.sort.first
      end

      def self.tall_variant(image, size, max=DEFAULT_MAX)
        width  = pick_smallest image.width, size*3, max
        height = pick_smallest image.height, size, max
        image.dup.thumbnail_image width, height: , crop: :attention
      end

      def self.wide_variant(image, size, max=DEFAULT_MAX)
        width  = pick_smallest image.width, size, max
        height = pick_smallest image.height, size*3, max
        image.dup.thumbnail_image width, height: , crop: :attention
      end

      def self.new_variant(image, size, max=DEFAULT_MAX)
        return wide_variant(image, size) if extra_wide? image
        return tall_variant(image, size) if extra_tall? image
        full_variant(image, size)
      end

      def self.full_variant(image, max)
        return image.dup.thumbnail_image image.width, height: 1000000 if image.width < max 
        image.dup.thumbnail_image max, height: 1000000   
      end

      def self.file_type(path)
        File.directory?(path) ? 'dir' : File.extname(path).downcase.tr('.', '')
      end
    end
  end
end
