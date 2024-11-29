import ArgumentParser
import Foundation
import OSLog

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

    let logger = Logger(context: ["Command": "StartServerCommand"])

    enum CodingKeys: CodingKey {
        case _deviceIdentifier
        case _deviceName
        case _osVersion
        case _buildPath
        case forceInstall
        case notPrebuildServer
    }

    func run() async throws {
        logger.log("Running StartServerCommand")

        let selectedDevice = await getTestingDevice(deviceUUID: deviceIdentifier)
        await selectedDevice.prepareCacheIfNeeded(buildPath: buildPath, usePrebuildServer: !notPrebuildServer)

        let cloneDevices = await getTestsDevices(osVersion: osVersion, deviceName: deviceName)

        await withTaskGroup(of: Void.self) { group in
            for device in [selectedDevice] + cloneDevices {
                group.addTask {
                    guard await device.isDeviceToBooted() else {
                        logger.log("Device \(device.deviceIdentifier) is not booted. Skipping it.")
                        return
                    }

                    let isRunning = await device.isServerRunning()
                    let isRightVersion = await device.isRightVersion()
                    guard !isRunning || !isRightVersion else {
                        logger.log("Server running and right version. Skipping it.")
                        return
                    }

                    let appInstalled = await device.deviceContainsUIServerApp()

                    if !appInstalled || forceInstall {
                        await device.installServer(usePreBuilderServer: !forceInstall, buildPath: buildPath)
                    }

                    if await !device.isServerRunning() {
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
            logger.log("End of command")
        }
    }
}

func isArmMac(logger: Logger = Logger()) -> Bool {
    var systeminfo = utsname()
    uname(&systeminfo)
    let machine = withUnsafeBytes(of: &systeminfo.machine) { bufPtr -> String in
        let data = Data(bufPtr)
        if let lastIndex = data.lastIndex(where: { $0 != 0 }) {
            return String(data: data[0 ... lastIndex], encoding: .isoLatin1)!
        } else {
            return String(data: data, encoding: .isoLatin1)!
        }
    }
    logger.log(machine)
    return machine == "arm64"
}
