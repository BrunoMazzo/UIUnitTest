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
        
        await prepareCache()
        
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
    
    func prepareCache() async {
        let cacheFile = "\(String(buildPath.pathComponents.joined(separator: "/").dropFirst()))/build/Products/Release-iphonesimulator/ServerUITests-Runner.app"
        
        guard !FileManager.default.fileExists(atPath: cacheFile) else {
            return
        }
        
        if !forceInstall {
            await self.copyPreBuildServer(buildFolder: buildPath)
        } else {
            await self.buildUIServer(buildFolder: buildPath)
        }
    }
    
    func copyPreBuildServer(buildFolder: URL) async {
        let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
        
        try! FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(buildFolder.absoluteString)/build/Products/Release-iphonesimulator"), withIntermediateDirectories: true)
        //        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: buildFolder)
        
        let _: Data = await executeShellCommand("unzip -o \(serverRunnerZip.path) -d \(buildFolder.absoluteString)/build/Products/Release-iphonesimulator")
    }
    
    func buildUIServer(buildFolder: URL) async {
        print("buildUIServer")
        
        let serverRunnerZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
        
        //        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: buildFolder)
        
        let _: Data = await executeShellCommand("unzip -o \(serverRunnerZip.path) -d \(buildFolder.absoluteString)")
        
        let rootFolder = String(buildFolder.pathComponents.joined(separator: "/").dropFirst())
        
        let _: Data = await executeShellCommand("""
                xcodebuild -project \(rootFolder)/Server.xcodeproj \
                    -scheme ServerUITests -sdk iphonesimulator \
                    -destination "platform=iOS Simulator,id=\(deviceIdentifier)" \
                    -IDEBuildLocationStyle=Custom \
                    -IDECustomBuildLocationType=Absolute \
                    -IDECustomBuildProductsPath="\(rootFolder)/build/Products" \
                    build-for-testing
                """)
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
