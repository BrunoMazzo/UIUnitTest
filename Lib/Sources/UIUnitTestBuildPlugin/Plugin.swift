import Foundation
import PackagePlugin

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

@main
struct MyPlugin: BuildToolPlugin, XcodeBuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        []
    }

    /// 👇 This entry point is called when operating on an Xcode project.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        
        return [
            .buildCommand(
                displayName: "Start UI Test server",
                executable: try context.tool(named: "UIUnitTestCLI").path,
                arguments: [],
                environment: [:],
                outputFiles: []
            )
        ]
    }
}
#endif
