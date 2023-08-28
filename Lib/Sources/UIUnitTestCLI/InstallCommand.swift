import ArgumentParser
import Foundation


@available(macCatalyst 16.0, *)
struct InstallCommand: AsyncParsableCommand {
    
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false
    
//  DEVICE_NAME
    @Option
    var deviceName: String
    
//  TARGET_DEVICE_OS_VERSION
    @Option
    var osVersion: String

    mutating func run() async throws {
        
        print(ProcessInfo.processInfo.environment)
        
        var installedDevices = [Int]()
        
        // Start server on already openned devices
        try await installAndStartOnAllCloneDevices(installedDevices: &installedDevices)
    }
    
    func installAndStartOnAllCloneDevices(installedDevices: inout [Int]) async throws {
        let cloneDeviceLists: String = await executeShellCommand("xcrun simctl --set testing list")
        
        guard let versionsRegex = try? Regex("-- iOS \(osVersion.replacingOccurrences(of: ".", with: "\\.")) --\\n([\\n\\sA-Za-z\\d\\(\\)-]*)\\n--") else {
            return
        }
        
        guard let devices = try? versionsRegex.firstMatch(in: cloneDeviceLists)?.output[0] else {
            return
        }
        
        let allDevices = String(cloneDeviceLists[devices.range!])
        
        print(allDevices)
        
        let safeDeviceName = osVersion
            .replacingOccurrences(of: ".", with: "\\.")
            .replacingOccurrences(of: "(", with: "\\(")
            .replacingOccurrences(of: ")", with: "\\)")
        
        
        let deviceRegex = try! Regex("Clone ([0-9]*) of \(safeDeviceName) \\(([0-9A-F-]*)\\) \\(Booted\\)")
        for match in allDevices.matches(of: deviceRegex) {
            let deviceID = Int(String(allDevices[match.output[1].range!])) ?? 0
            
            guard !installedDevices.contains(deviceID) else {
                continue
            }
            
            let deviceIdentifier = String(allDevices[match.output[2].range!])
            
            let result: String = await executeShellCommand("xcrun simctl --set testing listapps \(deviceIdentifier)")
            
            let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
            //
            if !appInstalled || forceInstall {
                let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
                
                let tempDirectory = getTempFolder()
                
                let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
                
                await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
                
                let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
                
                await executeShellCommand("xcrun simctl --set testing install \(deviceIdentifier) \(rootFolder)/ServerUITests-Runner.app")
            }
            
            if await !isServerRunning(for: deviceID) {
                await launchUIServer(deviceIdentifier: deviceIdentifier, isCloneDevice: true)
                await waitForServerToStart(deviceID: deviceID)
            }
            
            installedDevices.append(deviceID)
        }
    }
    
//    kill $(ps aux | grep "[U]IUnitTestCLI monitor-for-new-devices-command" | awk '{print $2}')
    
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


func waitForServerToStart(deviceID: Int) async {
    while await !isServerRunning(for: deviceID) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

func isServerRunning(for deviceId: Int) async -> Bool {
    let defaultPort = 22087
    do {
        let _ = try await URLSession.shared.data(for: URLRequest(url: URL(string: "http://localhost:\(defaultPort + deviceId)/alive")!))
        return true
    } catch {
        return false
    }
}

func launchUIServer(deviceIdentifier: String, isCloneDevice: Bool = false) async {
    await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") launch \(deviceIdentifier) bruno.mazzo.ServerUITests.xctrunner")
}
