# frozen_string_literal: true

# Used constants:
# _none_

require 'json'

namespace :spm do
  desc 'Run test command'
  task :test_command do |task|
    Utils.print_header 'Running `generate-code-for-resources` test'
    
    File.delete?('swiftgen.yml') if File.exists?('swiftgen.yml')
    Utils.run('swift package --allow-writing-to-package-directory generate-code-for-resources config init', task, xcrun: true)

    # check result
    if File.exists?('swiftgen.yml')
      File.delete('swiftgen.yml')
      puts 'Test successful!'
    else
      raise 'Test failed, output file does not exist!'
    end
  end
end
