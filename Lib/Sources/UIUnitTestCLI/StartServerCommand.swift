import ArgumentParser
import Foundation

enum UIUnitTestErrors: Error {
    case appNotInstalled
}

struct StartServerCommand: AsyncParsableCommand {
    
    mutating func run() async throws {
        let result: String = await executeShellCommand("xcrun simctl listapps booted")
        
        let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
        
        guard appInstalled else {
            throw UIUnitTestErrors.appNotInstalled
        }
        
        await executeShellCommand("xcrun simctl launch booted bruno.mazzo.ServerUITests.xctrunner")
    }
}
