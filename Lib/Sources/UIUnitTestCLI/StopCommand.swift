import ArgumentParser
import Foundation

@available(macOS 13.0, *)
struct StopCommand: AsyncParsableCommand {

    mutating func run() async throws {
        // Stop all servers
        let _: Data = await executeShellCommand("kill $(ps aux | grep \"[S]erverUITest\" | awk '{print $2}')")

        // Stop any monitor
        let _: Data = await executeShellCommand("kill $(ps aux | grep \"[U]IUnitTestCLI monitor-for-new-devices-command\" | awk '{print $2}')")

    }
}
