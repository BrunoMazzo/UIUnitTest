import Foundation
import PackagePlugin

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    @main
    struct MyPlugin: BuildToolPlugin, XcodeBuildToolPlugin {
        func createBuildCommands(context _: PackagePlugin.PluginContext, target _: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
            []
        }

        /// 👇 This entry point is called when operating on an Xcode project.
        func createBuildCommands(context: XcodePluginContext, target _: XcodeTarget) throws -> [Command] {
            return try [
                .buildCommand(
                    displayName: "Start UI Test server",
                    executable: context.tool(named: "UIUnitTestCLI").path,
                    arguments: [],
                    environment: [:],
                    outputFiles: []
                ),
            ]
        }
    }
#endif
