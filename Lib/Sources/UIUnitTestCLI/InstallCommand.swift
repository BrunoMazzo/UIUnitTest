import ArgumentParser
import Foundation


struct InstallCommand: AsyncParsableCommand {
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false

    mutating func run() async throws {
        let result: String = await executeShellCommand("xcrun simctl listapps booted")
        
        let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
        
        if !appInstalled || forceInstall {
            let serverRunnerZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
            
            let tempDirectory = getTempFolder()
            
            let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
            
            await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
            
            let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
            
            await executeShellCommand("xcrun simctl install booted \(rootFolder)/ServerUITests-Runner.app")
        }
    }
    
    func getTempFolder() -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempUIUnitTestDirectory = tempDirectory.appendingPathComponent("UIUnitTest/")
        if !FileManager.default.fileExists(atPath: tempUIUnitTestDirectory.relativePath) {
            try! FileManager.default.createDirectory(at: tempUIUnitTestDirectory, withIntermediateDirectories: true)
        }
        
        return tempUIUnitTestDirectory
    }
    
    func copyFile(file initialPath: URL, toFolder folder: URL)  -> URL {
        let newPath = folder.appendingPathComponent(initialPath.lastPathComponent, isDirectory: false)
        
//        let newPath = folder.appending(path: initialPath.lastPathComponent, directoryHint: .notDirectory)
        
        if FileManager.default.fileExists(atPath: newPath.relativePath) {
            try? FileManager.default.removeItem(at: newPath)
        }
        
        try! FileManager.default.copyItem(at: initialPath, to: newPath)
        return newPath
    }
}
