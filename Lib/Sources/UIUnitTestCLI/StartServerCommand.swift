import ArgumentParser
import Foundation

enum UIUnitTestErrors: Error {
    case appNotInstalled
}

struct StartServerCommand: AsyncParsableCommand {
    
    @Option
    var deviceIdentifier: String
    
    @Flag
    var forceInstall = false
    
    @Flag
    var notPrebuildServer = false
    
    mutating func run() async throws {
        if isArmMac() && notPrebuildServer {
            let result: String = await executeShellCommand("xcrun simctl listapps \(deviceIdentifier)")
            
            let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
            
            if !appInstalled || forceInstall {
                let serverRunnerZip = Bundle.module.url(forResource: "PreBuild", withExtension: ".zip")!
                
                let tempDirectory = getTempFolder()
                
                let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
                
                await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
                
                let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
                
                await executeShellCommand("xcrun simctl install \(deviceIdentifier) \(rootFolder)/ServerUITests-Runner.app")
            }
            
            await launchUIServer(deviceIdentifier: deviceIdentifier, isCloneDevice: false)
        } else {
            let serverRunnerZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
            
            let tempDirectory = getTempFolder()
            
            let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)
            
            await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
            
            let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
            
            
            await executeTestUntilServerStarts("""
                xcodebuild -project \(rootFolder)/Server.xcodeproj \
                    -scheme ServerUITests -sdk iphonesimulator \
                    -destination "platform=iOS Simulator,id=\(deviceIdentifier)" \
                    test &
                """)
        }
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
        
        if FileManager.default.fileExists(atPath: newPath.relativePath) {
            try? FileManager.default.removeItem(at: newPath)
        }
        
        try! FileManager.default.copyItem(at: initialPath, to: newPath)
        return newPath
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
}
