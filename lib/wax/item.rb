# frozen_string_literal: true

require 'forwardable'

module Wax
  class Item
    attr_reader :pid, :label, :metadata, :assets, :derivatives

    def initialize(pid, opts)
      @pid          = pid
      @label        = opts.fetch 'label',        pid
      @metadata     = opts.fetch 'metadata',     {}
      @assets       = opts.fetch 'assets',       {}
      @derivatives  = opts.fetch 'derivatives',  {}
    end

    def to_h
      {
        'pid' => pid,
        'label' => label,
        'metadata' => metadata,
        'assets' => assets,
        'derivatives' => derivatives
      }
    end

    def compact_hash
      to_h.compact.delete_if { |_k, value| value.empty? }
    end

    def simple_derivatives=(derivatives)
      @derivatives.to_h['simple'] = derivatives
    end

    def clear_simple_derivatives
      @derivatives.to_h.delete 'simple'
    end

    def clear_assets
      @assets = {}
    end
  end
end
