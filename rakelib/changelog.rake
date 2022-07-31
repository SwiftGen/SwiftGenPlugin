# frozen_string_literal: true

# Used constants:
# _none_

require_relative 'check_changelog'

namespace :changelog do
  desc 'Add the empty CHANGELOG entries after a new release'
  task :reset do
    changelog = File.read('CHANGELOG.md')
    abort('A Stable entry already exists') if changelog =~ /^##\s*Stable Branch$/
    changelog.sub!(/^##[^#]/, "#{header}\\0")
    File.write('CHANGELOG.md', changelog)
  end

  def header
    <<-HEADER.gsub(/^\s*\|/, '')
      |## Stable Branch
      |
      |### Breaking Changes
      |
      |_None_
      |
      |### New Features
      |
      |_None_
      |
      |### Bug Fixes
      |
      |_None_
      |
      |### Internal Changes
      |
      |_None_
      |
    HEADER
  end

  desc 'Check if links to issues and PRs use matching numbers between text & link'
  task :check do
    warnings = check_changelog
    if warnings.empty?
      puts "\u{2705}  All entries seems OK (end with period + 2 spaces, correct links)"
    else
      puts "\u{274C}  Some warnings were found:\n" + Array(warnings.map do |warning|
        " - Line #{warning[:line]}: #{warning[:message]}"
      end).join("\n")
      exit 1
    end
  end

  LINKS_SECTION_TITLE = 'Changes in core dependencies of SwiftGenPlugin'

  desc 'Add links to other CHANGELOGs in the topmost SwiftGen CHANGELOG entry'
  task :links do
    changelog = File.read('CHANGELOG.md')
    topmost = /^### (.*)/.match(changelog) || ['', '']
    abort('Links seems to already exist for latest version entry') if topmost[1] == LINKS_SECTION_TITLE
    links = linked_changelogs(
      swiftgen: Utils.swiftgen_version
    )
    changelog.sub!(/^##[^#].*$\n/, "\\0\n#{links}")
    File.write('CHANGELOG.md', changelog)
  end

  def linked_changelogs(swiftgen: nil)
    <<-LINKS.gsub(/^\s*\|/, '')
      |### #{LINKS_SECTION_TITLE}
      |
      |* [SwiftGen #{swiftgen}](https://github.com/SwiftGen/SwiftGen/blob/#{swiftgen}/CHANGELOG.md)
    LINKS
  end
end
