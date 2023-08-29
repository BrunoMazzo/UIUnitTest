import ArgumentParser
import Foundation

@main
struct UIUnitTestCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility for performing operations for UIUnitTest lib.",
        version: "1.0.0",
        subcommands: [SetupCommand.self, InstallCommand.self, StartServerCommand.self, MonitorForNewDevicesCommand.self, StopCommand.self],
        defaultSubcommand: StartServerCommand.self)
}
