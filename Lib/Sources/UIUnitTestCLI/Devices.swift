import Foundation

let CurrentServerVersion = "2"

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
    
    func buildUIServer(buildFolder: URL) async -> String {
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
                    -derivedData="\(rootFolder)/derivedData" \
                    build-for-testing
                """)
        
        return URL(string: rootFolder)!.appending(path: "build/Products/Release-iphonesimulator").absoluteString
    }
    
    func buildAndInstallUIServer(buildFolder: URL) async {
        print("buildAndInstallUIServer")
        let rootFolder = await buildUIServer(buildFolder: buildFolder)
        await installUIServer(rootFolder: rootFolder)
    }
    
    func installServer(usePreBuilderServer: Bool = true, buildPath: URL) async {
        print("Install server")
        print("buildPath: \(buildPath.absoluteString)")
        let cacheFile = "\(String(buildPath.pathComponents.joined(separator: "/").dropFirst()))/build/Products/Release-iphonesimulator/ServerUITests-Runner.app"
        print(cacheFile)
        
        print("Checking for cache")
        
        if FileManager.default.fileExists(atPath: cacheFile) {
            print("Cache found. Using it.")
            await installUIServer(rootFolder: URL(string: buildPath.absoluteString)!.appending(path: "build/Products/Release-iphonesimulator").absoluteString)
            return
        }
        
        print("Cache not found.")
        
        if usePreBuilderServer {
            print("Installing pre build version.")
            await self.installPreBuildUIServer(buildFolder: buildPath)
        } else {
            print("Building new server app for install.")
            await self.buildAndInstallUIServer(buildFolder: buildPath)
        }
    }
    
    // Only for m1 for now
    func installPreBuildUIServer(buildFolder: URL) async {
        let serverRunnerZip = Bundle.module.url(forResource: isArmMac() ? "PreBuild" : "PreBuild-intel", withExtension: ".zip")!
        
        try! FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(buildFolder.absoluteString)/build/Products/Release-iphonesimulator"), withIntermediateDirectories: true)
//        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: buildFolder)
        
        let _: Data = await executeShellCommand("unzip -o \(serverRunnerZip.path) -d \(buildFolder.absoluteString)/build/Products/Release-iphonesimulator")
        
        let rootFolder = String(buildFolder.pathComponents.joined(separator: "/").dropFirst())
        
        await installUIServer(rootFolder: "\(buildFolder.absoluteString)/build/Products/Release-iphonesimulator")
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
        print(folder)
        let newPath = folder.appendingPathComponent(initialPath.lastPathComponent, isDirectory: false)
        let newFileURL = URL(filePath: newPath.absoluteString)
        
        //        let newPath = folder.appending(path: initialPath.lastPathComponent, directoryHint: .notDirectory)
        
        print(FileManager.default.fileExists(atPath: initialPath.absoluteString))
        print(FileManager.default.fileExists(atPath: newFileURL.absoluteString))
        
        if FileManager.default.fileExists(atPath: newFileURL.absoluteString) {
            try? FileManager.default.removeItem(at: newFileURL)
        }
        
        print(initialPath)
        print(newPath)
        
        try! FileManager.default.copyItem(at: initialPath, to: newFileURL)
        return newPath
    }
    
    func prepareCacheIfNeeded(buildPath: URL, usePrebuildServer: Bool) async {
        let cacheFile = "\(String(buildPath.pathComponents.joined(separator: "/").dropFirst()))/build/Products/Release-iphonesimulator/ServerUITests-Runner.app"
        
        if FileManager.default.fileExists(atPath: cacheFile) {
            let file = URL(fileURLWithPath: "\(cacheFile)/Info.plist")
            if let pListData = try? Data(contentsOf: file), let infoPlist = try? PropertyListSerialization.propertyList(from: pListData, options: [], format: nil) as? [String: Any] {
                let bundleVersion = infoPlist["CFBundleVersion"] as? String
                if bundleVersion == CurrentServerVersion {
                    return
                }
            }
        }
        
        if usePrebuildServer {
            await self.copyPreBuildServer(buildFolder: buildPath)
        } else {
            _ = await buildUIServer(buildFolder: buildPath)
        }
    }
    
    func copyPreBuildServer(buildFolder: URL) async {
        let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
        
        try! FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(buildFolder.absoluteString)/build/Products/Release-iphonesimulator"), withIntermediateDirectories: true)
        //        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: buildFolder)
        
        let _: Data = await executeShellCommand("unzip -o \(serverRunnerZip.path) -d \(buildFolder.absoluteString)/build/Products/Release-iphonesimulator")
    }
}
