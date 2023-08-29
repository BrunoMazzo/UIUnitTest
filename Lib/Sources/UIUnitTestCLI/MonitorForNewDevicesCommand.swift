import ArgumentParser
import Foundation

@available(macOS 13.0, *)
struct MonitorForNewDevicesCommand: AsyncParsableCommand {
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
        
        while true {
            try await installAndStartOnAllCloneDevices(installedDevices: &installedDevices)
            try await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    
    func installAndStartOnAllCloneDevices(installedDevices: inout [Int]) async throws {
        let devices = await getDevices(osVersion: osVersion, deviceName: deviceName, excludeDevices: installedDevices)
        
        for device in devices {
            
            let appInstalled = await device.deviceContainsUIServerApp()
            
            if !appInstalled || forceInstall {
                await device.installUIServer()
            }
            
            if await !device.isServerRunning() {
                await device.launchUIServer()
                await device.waitForServerToStart()
            }
            
            installedDevices.append(device.deviceID)
        }
    }
}
