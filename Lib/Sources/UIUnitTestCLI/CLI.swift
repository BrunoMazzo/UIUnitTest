import Foundation

@available(iOS 16.0, *)
@available(macOS 13.0, *)
@main
struct UserFetcher {
    
    static func getTempFolder() -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempUIUnitTestDirectory = tempDirectory.appendingPathComponent("UIUnitTest/")
        if !FileManager.default.fileExists(atPath: tempUIUnitTestDirectory.relativePath) {
            try! FileManager.default.createDirectory(at: tempUIUnitTestDirectory, withIntermediateDirectories: true)
        }
        
        return tempUIUnitTestDirectory
    }
    
    static func copyFile(file initialPath: URL, toFolder folder: URL)  -> URL {
        let newPath = folder.appending(path: initialPath.lastPathComponent, directoryHint: .notDirectory)
        
        if FileManager.default.fileExists(atPath: newPath.relativePath) {
            try? FileManager.default.removeItem(at: newPath)
        }
        
        
        
        try! FileManager.default.copyItem(at: initialPath, to: newPath)
        return newPath
    }
    
    static func main() async throws {
        let serverRunnerZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
        
        let tempDirectory = getTempFolder()
        
        let testRunnerZip = copyFile(file: serverRunnerZip, toFolder: tempDirectory)

        await executeShellCommand("unzip -o \(testRunnerZip.path) -d \(tempDirectory.relativePath)")
        
        let rootFolder = String(tempDirectory.pathComponents.joined(separator: "/").dropFirst())
        
        await executeShellCommand("xcrun simctl install booted \(rootFolder)/ServerUITests-Runner.app")
        await executeShellCommand("xcrun simctl launch booted bruno.mazzo.ServerUITests.xctrunner")
        
        
        
//        let device = await openDevices().first!
//        await boot()
        
        //  xcrun simctl launch booted bruno.mazzo.ServerUITests.xctrunner
//
//        await executeShellCommand("xcodebuild -xctestrun \(rootFolder)/Server-config.xctestrun  -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' test-without-building")
        
//        await executeShellCommand("xcodebuild -project \(rootFolder)/Server/Server.xcodeproj -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=\(device.name)' test")
        
//        while true {
//            await executeShellCommand("xcodebuild -project \(rootFolder)/Server/Server.xcodeproj -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' -clonedSourcePackagesDirPath \(rootFolder)/Packages -derivedDataPath \(rootFolder)/build  CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO test")
//        }
//
        
        // xcrun simctl list devices -j
        // xcrun simctl install booted ServerUITests-Runner.app
        
        // Run Server Test
//        let server = executeShellCommand("xcodebuild -workspace UIUnitTest.xcworkspace -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=\(device.name)' test")
        
//        let server = executeShellCommand("xcodebuild -project \(rootFolder)/Server/Server.xcodeproj -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' test")
        
//        try await Task.sleep(for: .seconds(10))
//
//        // Run client tests
//        let client = executeShellCommand("xcodebuild -workspace UIUnitTest.xcworkspace -scheme Client -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' test")
        
        // Stop Server
//        client.waitUntilExit()
    }
    
    static func release() async {
        await executeShellCommand("zip -r Server.zip Server")
        
        
        
        
    }
}

@available(macOS 12.0, *)
func executeShellCommand(_ command: String) async {
    
    print("Executing command: \(command)")
    
    let task = Process()
    let pipe = Pipe()
        
    task.standardOutput = pipe
    task.standardError = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil
    task.arguments = ["-c", command]
    task.launch()
    

//    var data = Data()
    
    do {
        for try await line in pipe.fileHandleForReading.bytes {
//            data.append(Data(bytes: [line], count: 1))
            
            if let string = String(bytes: [line], encoding: .utf8) {
                print(string, terminator: "")
            }
        }
    } catch {
        print("Error: --------------------------------------")
        print(error.localizedDescription)
        print("Error: --------------------------------------")
    }
    
//    return data
}

//@available(macOS 12.0, *)
//func executeShellCommand2(_ command: String) async -> String {
//    let data: Data = await executeShellCommand(command)
//    let output = String(data: data, encoding: .utf8)!
//    return output
//}
//
