# frozen_string_literal: true

require 'forwardable'

module Wax
  class Item
    attr_reader :pid, :label, :order, :metadata, :assets, :derivatives, :thumbnail, :banner

    def initialize(pid, opts)
      @pid          = pid
      @label        = opts.fetch 'label',        pid
      @order        = opts.fetch 'order',        ''
      @metadata     = opts.fetch 'metadata',     {}
      @assets       = opts.fetch 'assets',       {}
      @derivatives  = opts.fetch 'derivatives',  {}
      @thumbnail    = opts.fetch 'thumbnail',    ''
      @banner       = opts.fetch 'banner',       ''
    end

    def to_h
      {
        'pid' => pid,
        'label' => label,
        'order' => order,
        'thumbnail' => thumbnail,
        'banner' => banner,
        'metadata' => metadata,
        'assets' => assets,
        'derivatives' => derivatives
      }
    end

    def to_yaml
      compact_hash.to_yaml
    end

    def to_page_yaml
      "#{compact_hash.except('assets').to_yaml}---\n"
    end

    def compact_hash
      to_h.compact.delete_if { |_k, value| value.empty? }
    end

    def simple_derivatives=(derivatives)
      @derivatives.to_h['simple'] = derivatives
      @thumbnail = derivatives.first[1]['thumbnail']
      @banner = derivatives.first[1]['banner']
    end

    def clear_simple_derivatives
      @derivatives.to_h.delete 'simple'
      @thumbnail = nil
      @banner    = nil
    end

    def clear_assets
      @assets = {}
    end
  end
end
