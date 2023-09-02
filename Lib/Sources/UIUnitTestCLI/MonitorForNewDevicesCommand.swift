import ArgumentParser
import Foundation

@available(macOS 13.0, *)
struct MonitorForNewDevicesCommand: AsyncParsableCommand {
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false
    
    @Flag
    var verbose = false
    
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
    
    func print(_ message: String) {
        if verbose {
            Swift.print(message)
        }
    }
    
    mutating func run() async throws {
        var installedDevices = [Int]()
        
        while true {
            try await installAndStartOnAllCloneDevices(installedDevices: &installedDevices)
            try await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    
    func installAndStartOnAllCloneDevices(installedDevices: inout [Int]) async throws {
        print("Getting devices")
        let devices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName, excludeDevices: installedDevices)
        
        print("\(devices.count) devices found")
        
        for device in devices {
            
            print("Checking for the server on device: \(device.deviceIdentifier)")
            let appInstalled = await device.deviceContainsUIServerApp()
            
            if !appInstalled || forceInstall {
                print("Installing server on device: \(device.deviceIdentifier)")
                await device.installPreBuildUIServer()
            }
            
            if await !device.isServerRunning() {
                print("Launching server on device: \(device.deviceIdentifier)")
                await device.launchUIServer()
//                await device.waitForServerToStart()
            }
            
            installedDevices.append(device.deviceID)
        }
    }
}
