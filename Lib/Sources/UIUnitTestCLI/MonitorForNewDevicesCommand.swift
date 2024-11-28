import ArgumentParser
import Foundation

@available(macOS 13.0, *)
struct MonitorForNewDevicesCommand: AsyncParsableCommand {
    @Flag(help: "Reinstall the server even if the server already installed")
    var forceInstall = false

    @Flag
    var notPrebuildServer = false

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

    @Option(name: .customLong("build-path"))
    var _buildPath: String?

    var buildPath: URL {
        let path = _buildPath ?? "\(ProcessInfo.processInfo.environment["PROJECT_DIR"]!)/.uiUnitTest"
        return URL(string: path)!
    }

    func print(_ message: String) {
        if verbose {
            Swift.print(message)
        }
    }

    let logger = Logger(context: ["Command" : "MonitorForNewDevicesCommand"])

    enum CodingKeys: CodingKey {
        case forceInstall
        case notPrebuildServer
        case verbose
        case _deviceIdentifier
        case _deviceName
        case _osVersion
        case _buildPath
    }

    mutating func run() async throws {
        while true {
            try await installAndStartOnAllCloneDevices()
            try await Task.sleep(for: .seconds(0.5))
        }
    }

    func installAndStartOnAllCloneDevices() async throws {
        logger.log("Getting devices")

        let selectedDevice = await getTestingDevice(deviceUUID: deviceIdentifier)
        await selectedDevice.prepareCacheIfNeeded(buildPath: buildPath, usePrebuildServer: !notPrebuildServer)

        let cloneDevices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName)

        let devices = [selectedDevice] + cloneDevices

        logger.log("\(devices.count) devices found")

        await withTaskGroup(of: Void.self) { group in
            for device in devices {
                group.addTask {
                    guard await device.isDeviceToBooted() else {
                        logger.log("Device \(device.deviceIdentifier) is not booted. Skipping it.")
                        return
                    }

                    let isReady = await device.isServerRunning()
                    let isRightVersion = await device.isRightVersion()
                    guard !isReady || !isRightVersion else {
                        return
                    }

                    logger.log("Checking for the server on device: \(device.deviceIdentifier)")
                    let appInstalled = await device.deviceContainsUIServerApp()

                    if !appInstalled || forceInstall {
                        logger.log("Installing server on device: \(device.deviceIdentifier)")
                        await device.installServer(usePreBuilderServer: !forceInstall, buildPath: buildPath)
                    }

                    if await !device.isServerRunning() {
                        logger.log("Launching server on device: \(device.deviceIdentifier)")
                        await device.launchUIServer()
                        await device.waitForServerToStart()
                    }

                    if await !device.isRightVersion() {
                        await device.uninstallServer()
                        await device.installServer(usePreBuilderServer: !forceInstall, buildPath: buildPath)
                        await device.launchUIServer()
                        await device.waitForServerToStart()
                    }
                }
            }

            await group.waitForAll()
        }
    }
}
