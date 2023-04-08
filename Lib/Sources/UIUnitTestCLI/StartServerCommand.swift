import ArgumentParser
import Foundation

enum UIUnitTestErrors: Error {
    case appNotInstalled
}

struct StartServerCommand: AsyncParsableCommand {
    
    @Option
    var deviceIdentifier: String
    
    mutating func run() async throws {
//        let result: String = await executeShellCommand("xcrun simctl listapps booted")
//
//        let appInstalled = result.contains("bruno.mazzo.ServerUITests.xctrunner")
//
//        guard appInstalled else {
//            throw UIUnitTestErrors.appNotInstalled
//        }
        
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
        
//        -IDEBuildLocationStyle=Custom \
//        -IDECustomBuildLocationType=Absolute \
//        -IDECustomBuildProductsPath="$PWD/build/Products" \
        
//        await executeShellCommand("xcrun simctl launch booted bruno.mazzo.ServerUITests.xctrunner")
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
        let newPath = folder.appending(path: initialPath.lastPathComponent, directoryHint: .notDirectory)
        
        if FileManager.default.fileExists(atPath: newPath.relativePath) {
            try? FileManager.default.removeItem(at: newPath)
        }
        
        try! FileManager.default.copyItem(at: initialPath, to: newPath)
        return newPath
    }
}
