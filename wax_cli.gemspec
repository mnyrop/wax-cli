# frozen_string_literal: true

require_relative 'lib/wax/version'

Gem::Specification.new do |spec|
  spec.name = 'wax_cli'
  spec.version = Wax::VERSION
  spec.authors = ['marii nyrop']
  spec.email = ['marii@nyu.edu']

  spec.summary = 'Gem-packaged commands for building wax exhibits'
  spec.homepage = 'https://github.com/mnyrop/wax_cli'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mnyrop/wax_cli'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'bin'
  spec.executables = ['wax']
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'parallel'
  spec.add_dependency 'pdf-reader'
  spec.add_dependency 'rainbow', '~> 3.1'
  spec.add_dependency 'ruby-progressbar'
  spec.add_dependency 'ruby-vips'
  spec.add_dependency 'thor', '~> 1.2'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
