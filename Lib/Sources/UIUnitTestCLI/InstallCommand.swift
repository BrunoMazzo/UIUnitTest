import ArgumentParser
import Foundation


@available(macCatalyst 16.0, *)
struct InstallCommand: AsyncParsableCommand {
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false
    
//  DEVICE_NAME
    var deviceName: String = "iPhone 14"
    
//  TARGET_DEVICE_OS_VERSION
    var osVersion: String = "16.2"

    mutating func run() async throws {
        let cloneDeviceLists: String = await executeShellCommand("xcrun simctl --set testing list")
        
        let versionsRegex = try! Regex("-- iOS \(osVersion.replacingOccurrences(of: ".", with: "\\.")) --\\n([\\n\\sA-Za-z\\d\\(\\)-]*)\\n--")
        
        guard let devices = try? versionsRegex.firstMatch(in: cloneDeviceLists)?.output[0] else {
            print("Error regex")
            return
        }
        
        let allDevices = String(cloneDeviceLists[devices.range!])
        
        print(allDevices)
        
        let deviceRegex = try! Regex("Clone [0-9]* of \(deviceName) \\(([0-9A-F-]*)\\) \\(Booted\\)")
        for match in allDevices.matches(of: deviceRegex) {
            let deviceIdentifier = String(allDevices[match.output[1].range!])
            
            let result: String = await executeShellCommand("xcrun simctl --set testing listapps \(deviceIdentifier)")
            
//            let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
//
//            if !appInstalled || forceInstall {
                let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
                
                let tempDirectory = getTempFolder()
                
                let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
                
                await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
                
                let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
                
                await executeShellCommand("xcrun simctl --set testing install \(deviceIdentifier) \(rootFolder)/ServerUITests-Runner.app")
//            }
            
            await executeShellCommand("xcrun simctl --set testing launch \(deviceIdentifier) bruno.mazzo.ServerUITests.xctrunner")
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
