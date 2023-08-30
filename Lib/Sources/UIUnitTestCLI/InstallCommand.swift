import ArgumentParser
import Foundation

struct InstallCommand: AsyncParsableCommand {
    
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false

    @Option(name: .customLong("device-name"))
    var _deviceName: String?
    
    var deviceName: String {
        _deviceName ?? ProcessInfo.processInfo.environment["DEVICE_NAME"]!
    }
    
    @Option(name: .customLong("os-version"))
    var _osVersion: String?
    
    var osVersion: String {
        _osVersion ?? ProcessInfo.processInfo.environment["TARGET_DEVICE_OS_VERSION"]!
    }
    
    mutating func run() async throws {
        var installedDevices = [Int]()
        
        // Start server on already openned devices
        try await installAndStartOnAllCloneDevices(installedDevices: &installedDevices)
        
        let programPath = ProcessInfo.processInfo.arguments[0]
        
        executeBackgroundShellCommand("""
            \(programPath) monitor-for-new-devices-command --device-name "\(deviceName)" --os-version "\(osVersion)"
        """)
    }
    
    func installAndStartOnAllCloneDevices(installedDevices: inout [Int]) async throws {
        let devices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName, excludeDevices: installedDevices)
        
        for device in devices {
            
            let appInstalled = await device.deviceContainsUIServerApp()
            
            if !appInstalled || forceInstall {
                await device.installServer()
            }
            
            if await !device.isServerRunning() {
                await device.launchUIServer()
                await device.waitForServerToStart()
            }
            
            installedDevices.append(device.deviceID)
        }
    }
}

func getTestingDevice(deviceUUID: String) async -> Device {
    return Device(deviceIdentifier: deviceUUID, isCloneDevice: false, deviceID: 0)
}

func getTestsDevices(osVersion: String, deviceName: String, excludeDevices: [Int]) async -> [Device] {
    let cloneDeviceLists: String = await executeShellCommand("xcrun simctl --set testing list")
    
    guard let versionsRegex = try? Regex("-- iOS \(osVersion.replacingOccurrences(of: ".", with: "\\.")) --\\n([\\n\\sA-Za-z\\d\\(\\)-]*)\\n--") else {
        return []
    }
    
    guard let devices = try? versionsRegex.firstMatch(in: cloneDeviceLists)?.output[0] else {
        return []
    }
    
    let allDevices = String(cloneDeviceLists[devices.range!])
    
    print(allDevices)
    
    let safeDeviceName = deviceName
        .replacingOccurrences(of: ".", with: "\\.")
        .replacingOccurrences(of: "(", with: "\\(")
        .replacingOccurrences(of: ")", with: "\\)")
    
    let deviceRegex = try! Regex("Clone ([0-9]*) of \(safeDeviceName) \\(([0-9A-F-]*)\\) \\(Booted\\)")
    
    
    return allDevices.matches(of: deviceRegex).compactMap { match in
        let deviceID = Int(String(allDevices[match.output[1].range!])) ?? 0
        
        guard !excludeDevices.contains(deviceID) else {
            return nil
        }
        
        let deviceIdentifier = String(allDevices[match.output[2].range!])
        
        return Device(deviceIdentifier: deviceIdentifier, isCloneDevice: true, deviceID: deviceID)
    }
}
