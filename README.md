# SwiftGenPlugin

SwiftGen code generation for Swift packages that works on any machine. No installation required, simply add the package to your `Package.swift`'s dependencies:

```swift
  dependencies: [
    .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0")
  ]
```

## Using it as a (pre-)build tool

Adding SwiftGen as a prebuild tool will execute it and generate your files **before each build**.

### Add to Package.swift

After adding the dependency to your `Package.swift`, include the `SwiftGenPlugin` plugin in any targets for which you would like it to run.

```swift
  targets: [
    .target(
      name: "YourTargetName",
      dependencies: [],
      plugins: [
        .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
      ]
    )
  ]
```

### Add a SwiftGen config

Add a `swiftgen.yml` file to your project following the [configuration file format](https://github.com/SwiftGen/SwiftGen/blob/stable/Documentation/ConfigFile.md), and prefix each of your output paths with `${DERIVED_SOURCES_DIR}/`. Or set this globally in your configuration by setting the `output_dir` to that value.

Take a look at this repository's [swiftgen.yml](./Examples/top-level-swiftgen.yml) for an example.

### Supporting Multiple Targets

Each time the plugin is invoked it will look for a `swiftgen.yml` configuration file in 2 places:

1. The root of your package (same folder as `Package.swift`).
2. Your target's folder, for example `Sources/MyExample`.

It will invoke SwiftGen for each found configuration file, so you could choose either option, or combine both. This can be useful if you need some target-specific configuration and some shared configuration, without repeating yourself.

Do note that the paths (to resources) in a configuration will need to change depending on where the configuration is located:

1. Root configurations will need the full path to resources, such as `Sources/MyExample/Resources/Localizable.strings`. Or set the config's `input_dir` to `Sources/MyExample/Resources`. See an [example of a top-level configuration](./Examples/top-level-swiftgen.yml).
2. Target configurations will need the relative path to resources, such as `Resources/Localizable.strings`. Or set the config's `input_dir` to `Resources`. See an [example of a target specific configuration](./Examples/target-specific-swiftgen.yml).

## Using it as a command

You can **manually** invoke SwiftGen using the following command:

```bash
swift package --allow-writing-to-package-directory generate-code-for-resources
```

The command will automatically search for `swiftgen.yml` configuration files in each of your targets' (or top-level) folder, and invoke SwiftGen for them.

If you want to manually provide the configuration file and other settings, pass them along as extra arguments:

```bash
swift package --allow-writing-to-package-directory generate-code-for-resources --config MyConfig.yml
```

---

# Licence

This code and tool is under the MIT Licence. See the `LICENCE` file in this repository.

## Attributions

These plugins are powered by [SwiftGen](https://github.com/SwiftGen/SwiftGen).


It is currently mainly maintained by [@AliSoftware](https://github.com/AliSoftware) and [@djbe](https://github.com/djbe). But I couldn't thank enough all the other [contributors](https://github.com/SwiftGen/SwiftGen/graphs/contributors) to this tool along the different versions which helped make SwiftGen awesome! 🎉

If you want to contribute, don't hesitate to open a Pull Request, or even join the team!
