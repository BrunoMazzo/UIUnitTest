import ArgumentParser
import Foundation

@available(macOS 13.0, *)
struct SetupCommand: AsyncParsableCommand {
    
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false
    
    mutating func run() async throws {
        var installCommand = InstallCommand()
        installCommand.forceInstall = forceInstall

        try await installCommand.run()
        
        var startServerCommand = StartServerCommand()
        try await startServerCommand.run()
    }   
}
