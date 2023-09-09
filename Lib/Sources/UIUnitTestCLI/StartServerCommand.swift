import ArgumentParser
import Foundation

enum UIUnitTestErrors: Error {
    case appNotInstalled
}

struct StartServerCommand: AsyncParsableCommand {
    
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
    
    @Option(name: .customLong("build-path"))
    var _buildPath: String?
    
    var buildPath: URL {
        let path = _buildPath ?? "\(ProcessInfo.processInfo.environment["PROJECT_DIR"]!)/.uiUnitTest"
        return URL(string: path)!
    }
    
    @Flag
    var forceInstall = false
    
    @Flag
    var notPrebuildServer = false
    
    func run() async throws {
        print("Running StartServerCommand")
        
        let selectedDevice = await getTestingDevice(deviceUUID: deviceIdentifier)
        let cloneDevices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName)
        
        await withTaskGroup(of: Void.self) { group in
            for device in [selectedDevice] + cloneDevices {
                group.addTask {
                    guard await device.isDeviceToBooted() else {
                        print("Device \(device.deviceIdentifier) is not booted. Skipping it.")
                        return
                    }
                    
                    let appInstalled = await device.deviceContainsUIServerApp()
                    
                    if !appInstalled || forceInstall {
                        await device.installServer(usePreBuilderServer: !forceInstall, buildPath: buildPath)
                    }
                    
                    if await !device.isServerRunning() {
                        await device.launchUIServer()
//                        await device.waitForServerToStart()
                    }
                }
                
                await group.waitForAll()
            }
        }
    }
}

func isArmMac() -> Bool {
    var systeminfo = utsname()
    uname(&systeminfo)
    let machine = withUnsafeBytes(of: &systeminfo.machine) {bufPtr->String in
        let data = Data(bufPtr)
        if let lastIndex = data.lastIndex(where: {$0 != 0}) {
            return String(data: data[0...lastIndex], encoding: .isoLatin1)!
        } else {
            return String(data: data, encoding: .isoLatin1)!
        }
    }
    print(machine)
    return machine == "arm64"
}
