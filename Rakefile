#!/usr/bin/rake
# frozen_string_literal: true

require 'English'
require 'open-uri'
require 'tempfile'

unless defined?(Bundler)
  puts 'Please use bundle exec to run the rake command'
  exit 1
end

## [ Constants ] ##############################################################

MIN_XCODE_VERSION = 13.0
BUILD_DIR = File.absolute_path('./.build')

## [ Build Tasks ] ############################################################

namespace :spm do
  desc "Update SwiftGen in Package.swift"
  task :update_swiftgen, [:version] do |task, args|
    require 'octokit'

    client = Utils.octokit_client
    release = client.latest_release('SwiftGen/SwiftGen')
    asset = release.assets.find { |a| a.name.end_with? '.artifactbundle.zip' }

    raise 'Release asset not found' if asset.nil?

    # download bundle
    puts 'Downloading artifact bundle…'
    artifactBundle = Tempfile.new(['artifactbundle', '.zip'])
    artifactBundle << URI::open(asset.browser_download_url).read

    # calculate checksum
    puts 'Checksumming…'
    checksum = Utils::run("swift package compute-checksum #{artifactBundle.path}", task, formatter: :to_string).strip
    
    # update package file
    puts 'Updating `Package.swift`…'
    package = File.read('Package.swift')
    package.sub!(/https:\/\/.+\.artifactbundle\.zip/, asset.browser_download_url)
    package.sub!(/checksum: "\w+"/, "checksum: \"#{checksum}\"")
    File.write('Package.swift', package)

    Utils::print_info 'Done!'
  end
end

task :default => 'spm:test_command'
