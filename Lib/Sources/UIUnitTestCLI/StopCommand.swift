import ArgumentParser
import Foundation


@available(macCatalyst 16.0, *)
struct StopCommand: AsyncParsableCommand {
    
    mutating func run() async throws {
        // Stop all servers
        await executeShellCommand("kill $(ps aux | grep \"[S]erverUITest\" | awk '{print $2}')")
        
        // Stop any monitor
        await executeShellCommand("kill $(ps aux | grep \"[U]IUnitTestCLI monitor-for-new-devices-command\" | awk '{print $2}')")
        
    }
}
