//
// SwiftGenPlugin
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PackagePlugin

@main
struct SwiftGenPlugin: CommandPlugin {
  func performCommand(context: PluginContext, arguments: [String]) async throws {
    let swiftgen = try context.tool(named: "swiftgen")
    let fileManager = FileManager.default

    // if user provided arguments, use those
    if !arguments.isEmpty {
      try swiftgen.run(arguments: arguments, environment: env(context: context))
    } else {
      // otherwise scan for configs
      let configuration = context.package.directory.appending("swiftgen.yml")
      if fileManager.fileExists(atPath: configuration.string) {
        try swiftgen.run(configuration, environment: env(context: context))
      }

      // check each target
      let targets = context.package.targets.compactMap { $0 as? SourceModuleTarget }
      for target in targets {
        let configuration = target.directory.appending("swiftgen.yml")
        if fileManager.fileExists(atPath: configuration.string) {
          try swiftgen.run(configuration, environment: env(context: context, target: target))
        }
      }
    }
  }
}

private extension SwiftGenPlugin {
  // Environment content for correct code generation
  func env(context: PluginContext, target: SourceModuleTarget? = nil) -> [String: String] {
    [
      "PROJECT_DIR": context.package.directory.string,
      "TARGET_NAME": target?.name ?? "",
      "PRODUCT_MODULE_NAME": target?.moduleName ?? ""
    ]
  }
}

private extension PluginContext.Tool {
  /// Invoke the tool with the given configuration
  func run(_ configuration: Path, environment: [String: String]) throws {
    try run(
      arguments: [
        "config",
        "run",
        "--config",
        configuration.string
      ],
      environment: environment
    )
  }

  /// Invoke the tool with given list of arguments
  func run(arguments: [String], environment: [String: String]) throws {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: path.string)
    task.arguments = arguments
    task.environment = environment

    try task.run()
    task.waitUntilExit()

    // Check whether the subprocess invocation was successful.
    if task.terminationReason == .exit && task.terminationStatus == 0 {
      // do something?
    } else {
      let problem = "\(task.terminationReason):\(task.terminationStatus)"
      Diagnostics.error("\(name) invocation failed: \(problem)")
    }
  }
}
