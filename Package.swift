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
      url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.3/swiftgen-6.6.3.artifactbundle.zip",
      checksum: "caf1feaf93dd32bc5037f0b6ded8d0f4fe28ab5d2f6e5c3edf2572006ba0b7eb"
    )
  ]
)
