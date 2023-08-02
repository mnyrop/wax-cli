# frozen_string_literal: true

require 'thor'

require_relative 'commands/build'
require_relative 'commands/clobber'
require_relative 'commands/lint'

module Wax
  class CLI < Thor
    def self.exit_on_failure? = false

    map %w[--version -v] => :__print_version
    desc '--version, -v', 'Print the wax_cli version'
    def __print_version
      puts Wax::VERSION
    end

    desc 'build SUBCOMMANDS', 'List the build subcommands'
    subcommand 'build', Wax::Commands::Build

    desc 'clobber SUBCOMMANDS', 'List the clobber subcommands'
    subcommand 'clobber', Wax::Commands::Clobber

    desc 'lint SUBCOMMANDS', 'List the lint subcommands'
    subcommand 'lint', Wax::Commands::Lint
  end
end
