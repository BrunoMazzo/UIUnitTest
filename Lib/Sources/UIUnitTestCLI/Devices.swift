import Foundation

struct Device {
    var deviceIdentifier: String
    var isCloneDevice: Bool
    var deviceID: Int
    
    func isDeviceToBooted() async -> Bool {
        let deviceStatus: String = await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") list devices \(deviceIdentifier)")
        return deviceStatus.contains("(Booted)")
    }
    
    func waitForDeviceToBoot() async {
        let _: Data = await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") bootstatus \(deviceIdentifier)")
    }
    
    func deviceContainsUIServerApp() async -> Bool {
        let listOfApps = await listOfApps()
        return listOfApps.contains("bruno.mazzo.ServerUITests.xctrunner")
    }
    
    func listOfApps() async -> String {
        return await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") listapps \(deviceIdentifier)")
    }
    
    func waitForServerToStart() async {
        while await !isServerRunning() {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
    
    func isServerRunning() async -> Bool {
        let defaultPort = 22087
        do {
            let _ = try await URLSession.shared.data(for: URLRequest(url: URL(string: "http://localhost:\(defaultPort + deviceID)/alive")!))
            return true
        } catch {
            return false
        }
    }
    
    func buildUIServer() async -> String {
        let serverRunnerZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
        
        let tempDirectory = getTempFolder()
        
        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
        
        let _: Data = await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
        
        let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
        
        let _: Data = await executeShellCommand("""
                xcodebuild -project \(rootFolder)/Server.xcodeproj \
                    -scheme ServerUITests -sdk iphonesimulator \
                    -destination "platform=iOS Simulator,id=\(deviceIdentifier)" \
                    -IDEBuildLocationStyle=Custom \
                    -IDECustomBuildLocationType=Absolute \
                    -IDECustomBuildProductsPath="\(rootFolder)/build/Products" \
                    build-for-testing
                """)
        
        return URL(string: rootFolder)!.appending(path: "build/Products/Release-iphonesimulator").absoluteString
    }
    
    func buildAndInstallUIServer() async {
        let rootFolder = await buildUIServer()
        await installUIServer(rootFolder: rootFolder)
    }
    
    func installServer(usePreBuilderServer: Bool = true) async {
        if isArmMac() && usePreBuilderServer {
            await self.installPreBuildUIServer()
        } else {
            await self.buildAndInstallUIServer()
        }
    }
    
    // Only for m1 for now
    func installPreBuildUIServer() async {
        let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
        
        let tempDirectory = getTempFolder()
        
        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
        
        let _: Data = await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
        
        let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
        
        await installUIServer(rootFolder: rootFolder)
    }
    
    func installUIServer(rootFolder: String) async {
        let _: Data = await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") install \(deviceIdentifier) \(rootFolder)/ServerUITests-Runner.app")
    }
    
    func launchUIServer() async {
        let _: Data = await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") launch \(deviceIdentifier) bruno.mazzo.ServerUITests.xctrunner")
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
