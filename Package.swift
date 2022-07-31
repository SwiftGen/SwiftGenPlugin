// swift-tools-version: 5.6
import PackageDescription

let package = Package(
  name: "SwiftGenPlugin",
  products: [
    .plugin(name: "SwiftGenPlugin", targets: ["SwiftGenPlugin"]),
    .plugin(name: "SwiftGen-Generate", targets: ["SwiftGen-Generate"])
  ],
  dependencies: [],
  targets: [
    .plugin(
      name: "SwiftGenPlugin",
      capability: .buildTool(),
      dependencies: ["swiftgen"]
    ),
    .plugin(
      name: "SwiftGen-Generate",
      capability: .command(
        intent: .custom(
          verb: "generate-code-for-resources",
          description: "Creates type-safe for all your resources"
        ),
        permissions: [
          .writeToPackageDirectory(reason: "This command generates source code")
        ]
      ),
      dependencies: ["swiftgen"]
    ),
    .binaryTarget(
      name: "swiftgen",
      url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.0/swiftgen-6.6.0.artifactbundle.zip",
      checksum: "1f6f4739df2e3299a07682859f4c72c5e18b66a553f329f9cd3a8cfbcfa21917"
    )
  ]
)
