# frozen_string_literal: true

require_relative 'command/build'
require_relative 'command/clobber'
require_relative 'command/inspect'
require_relative 'command/lint'

module Wax
  class CLI < Thor
    map %w[--version -v] => :__print_version
    desc '--version, -v', 'Print the wax_cli version'
    def __print_version
      puts Wax::VERSION
    end

    desc 'build SUBCOMMANDS', 'List the build subcommands'
    subcommand 'build', Wax::Command::Build

    desc 'clobber SUBCOMMANDS', 'List the clobber subcommands'
    subcommand 'clobber', Wax::Command::Clobber

    desc 'inspect SUBCOMMANDS', 'List the inspect subcommands'
    subcommand 'inspect', Wax::Command::Inspect

    desc 'lint SUBCOMMANDS', 'List the lint subcommands'
    subcommand 'lint', Wax::Command::Lint
  end
end
