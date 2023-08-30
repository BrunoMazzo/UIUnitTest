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
    
    @Flag
    var forceInstall = false
    
    @Flag
    var notPrebuildServer = false
    
    mutating func run() async throws {
        let device = await getTestingDevice(deviceUUID: deviceIdentifier)
        
        let appInstalled = await device.deviceContainsUIServerApp()
        
        if !appInstalled || forceInstall {
            await device.installServer(usePreBuilderServer: !notPrebuildServer)
        }
        
        await device.launchUIServer()
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
