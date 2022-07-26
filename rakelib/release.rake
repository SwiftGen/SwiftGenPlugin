# frozen_string_literal: true

# Used constants:
# - BUILD_DIR

def first_match_in_file(file, regexp)
  File.foreach(file) do |line|
    m = regexp.match(line)
    return m if m
  end
end

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release'
  task :new => [:check_versions, :confirm, 'spm:test_command', :github]

  desc 'Check if all versions from the podspecs and CHANGELOG match'
  task :check_versions do
    results = []

    # Check if bundler is installed first, as we'll need it for the cocoapods task (and we prefer to fail early)
    `which bundler`
    results << Utils.table_result(
      $CHILD_STATUS.success?,
      'Bundler installed',
      'Please install bundler using `gem install bundler` and run `bundle install` first.'
    )
    changelog_has_stable = system("grep -qi '^## Stable Branch' CHANGELOG.md")
    results << Utils.table_result(
      !changelog_has_stable,
      'CHANGELOG, No stable',
      'Please remove section for stable branch in CHANGELOG'
    )

    exit 1 unless results.all?
  end

  desc "Ask to release"
  task :confirm do
    print "Release version new version [Y/n]? "
    exit 2 unless STDIN.gets.chomp == 'Y'
  end

  desc "Create a new GitHub release"
  task :github do
    require 'octokit'

    client = Utils.octokit_client
    tag = Utils.top_changelog_version
    body = Utils.top_changelog_entry

    raise 'Must be a valid version' if tag == 'Stable Branch'

    repo_name = File.basename(`git remote get-url origin`.chomp, '.git').freeze
    puts "Pushing release notes for tag #{tag}"
    client.create_release("SwiftGen/#{repo_name}", tag, name: tag, body: body)
  end
end
