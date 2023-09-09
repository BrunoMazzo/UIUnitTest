import ArgumentParser
import Foundation

actor InstalledDevices {
    var devicesIdentifiers = [String]()
    
    func checkDevice(_ device: Device) -> Bool {
        guard !devicesIdentifiers.contains(device.deviceIdentifier) else {
            return false
        }
        
        devicesIdentifiers.append(device.deviceIdentifier)
        return true
    }
}

@available(macOS 13.0, *)
struct MonitorForNewDevicesCommand: AsyncParsableCommand {
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false
    
    @Flag
    var verbose = false
    
    @Option(name: .customLong("device-identifier"))
    var _deviceIdentifier: String?
    
    var deviceIdentifier: String {
        _deviceIdentifier ?? ProcessInfo.processInfo.environment["TARGET_DEVICE_IDENTIFIER"]!
    }
    
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
        var installedDevices = InstalledDevices()
        
        while true {
            try await installAndStartOnAllCloneDevices(installedDevices: installedDevices)
            try await Task.sleep(nanoseconds: 500_000_000)
        }
    }
    
    func installAndStartOnAllCloneDevices(installedDevices: InstalledDevices) async throws {
        print("Getting devices")
        
        let selectedDevice = await getTestingDevice(deviceUUID: deviceIdentifier)
        let cloneDevices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName)
        
        let devices = [selectedDevice] + cloneDevices
    
        print("\(devices.count) devices found")
        
        for device in devices {
            
            guard await device.isDeviceToBooted() else {
                print("Device \(device.deviceIdentifier) is not booted. Skipping it.")
                continue
            }
            
            guard await installedDevices.checkDevice(device) else {
                continue
            }
            
            print("Checking for the server on device: \(device.deviceIdentifier)")
            let appInstalled = await device.deviceContainsUIServerApp()
            
            
            if !appInstalled || forceInstall {
                print("Installing server on device: \(device.deviceIdentifier)")
                await device.installServer()
            }
            
            if await !device.isServerRunning() {
                print("Launching server on device: \(device.deviceIdentifier)")
                await device.launchUIServer()
//                await device.waitForServerToStart()
            }
        }
    }
}
