import Foundation

let CurrentServerVersion = 4

struct Device {
    var deviceIdentifier: String
    var isCloneDevice: Bool
    var deviceID: Int
    let logger: Logger

    var serverPort: Int {
        let defaultPort = 22087
        return defaultPort + deviceID
    }

    init(deviceIdentifier: String, isCloneDevice: Bool, deviceID: Int, logger: Logger) {
        self.deviceIdentifier = deviceIdentifier
        self.isCloneDevice = isCloneDevice
        self.deviceID = deviceID
        self.logger = logger.childLogger(mergeContext: ["DeviceIdentifier": deviceIdentifier])
    }

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
        logger.log("Awaiting for server to start...")
        while await !isServerRunning() {
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }

    func isServerRunning() async -> Bool {
        do {
            let _ = try await URLSession.shared.data(for: URLRequest(url: URL(string: "http://localhost:\(serverPort)/alive")!))
            logger.log("Server is running")
            return true
        } catch {
            logger.log("Server is not running")
            return false
        }
    }

    func isRightVersion() async -> Bool {
        struct ServerVersionResponse: Codable {
            let data: Int
        }
        let decoder = JSONDecoder()

        logger.log("Checking version...")
        do {
            let (versionData, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "http://localhost:\(serverPort)/server-version")!))
            let serverVersion = try decoder.decode(ServerVersionResponse.self, from: versionData)
            logger.log("Server version: \(serverVersion.data)")
            return serverVersion.data == CurrentServerVersion
        } catch {
            logger.log("Failed to get version")
            return false
        }
    }

    func uninstallServer() async {
        logger.log("Uninstalling server...")
        let _: Data = await executeShellCommand("xcrun simctl \(isCloneDevice ? "--set testing" : "") uninstall \(deviceIdentifier) bruno.mazzo.ServerUITests.xctrunner")
    }

    func buildUIServer(buildFolder: URL) async -> String {
        logger.log("Building app...")

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
        logger.log("buildAndInstallUIServer")
        let rootFolder = await buildUIServer(buildFolder: buildFolder)
        await installUIServer(rootFolder: rootFolder)
    }

    func installServer(usePreBuilderServer: Bool = true, buildPath: URL) async {
        logger.log("Install server")
        logger.log("buildPath: \(buildPath.absoluteString)")
        let cacheFile = "\(String(buildPath.pathComponents.joined(separator: "/").dropFirst()))/build/Products/Release-iphonesimulator/ServerUITests-Runner.app"
        logger.log(cacheFile)

        logger.log("Checking for cache")

        if FileManager.default.fileExists(atPath: cacheFile) {
            logger.log("Cache found. Using it.")
            await installUIServer(rootFolder: URL(string: buildPath.absoluteString)!.appending(path: "build/Products/Release-iphonesimulator").absoluteString)
            return
        }

        logger.log("Cache not found.")

        if usePreBuilderServer {
            logger.log("Installing pre build version.")
            await installPreBuildUIServer(buildFolder: buildPath)
        } else {
            logger.log("Building new server app for install.")
            await buildAndInstallUIServer(buildFolder: buildPath)
        }
    }

    // Only for m1 for now
    func installPreBuildUIServer(buildFolder: URL) async {
        let serverRunnerZip = Bundle.module.url(forResource: isArmMac() ? "PreBuild" : "PreBuild-intel", withExtension: ".zip")!

        try! FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(buildFolder.absoluteString)/build/Products/Release-iphonesimulator"), withIntermediateDirectories: true)
//        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: buildFolder)

        let _: Data = await executeShellCommand("unzip -o \(serverRunnerZip.path) -d \(buildFolder.absoluteString)/build/Products/Release-iphonesimulator")

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

    func copyFile(file initialPath: URL, toFolder folder: URL) -> URL {
        logger.log(folder)
        let newPath = folder.appendingPathComponent(initialPath.lastPathComponent, isDirectory: false)
        let newFileURL = URL(filePath: newPath.absoluteString)

        //        let newPath = folder.appending(path: initialPath.lastPathComponent, directoryHint: .notDirectory)

        logger.log(FileManager.default.fileExists(atPath: initialPath.absoluteString))
        logger.log(FileManager.default.fileExists(atPath: newFileURL.absoluteString))

        if FileManager.default.fileExists(atPath: newFileURL.absoluteString) {
            try? FileManager.default.removeItem(at: newFileURL)
        }

        logger.log(initialPath)
        logger.log(newPath)

        try! FileManager.default.copyItem(at: initialPath, to: newFileURL)
        return newPath
    }

    func prepareCacheIfNeeded(buildPath: URL, usePrebuildServer: Bool) async {
        let cacheFile = "\(String(buildPath.pathComponents.joined(separator: "/").dropFirst()))/build/Products/Release-iphonesimulator/ServerUITests-Runner.app"

        if FileManager.default.fileExists(atPath: cacheFile) {
            let file = URL(fileURLWithPath: "\(cacheFile)/PlugIns/ServerUITests.xctest/Info.plist")
            if let pListData = try? Data(contentsOf: file), let infoPlist = try? PropertyListSerialization.propertyList(from: pListData, options: [], format: nil) as? [String: Any] {
                let bundleVersion = infoPlist["CFBundleVersion"] as? String
                if bundleVersion == "\(CurrentServerVersion)" {
                    logger.log("Cache is up to date")
                    return
                }
            } else {
                logger.log("Plugin info.plist not found")
            }
        } else {
            logger.log("Cache file not found")
        }

        logger.log("Cache is not up to date")
        try? FileManager.default.removeItem(atPath: cacheFile)

        if usePrebuildServer {
            logger.log("Copied prebuild server")
            await copyPreBuildServer(buildFolder: buildPath)
        } else {
            logger.log("Builded server")
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
