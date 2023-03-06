import Foundation

@available(iOS 16.0, *)
@available(macOS 13.0, *)
@main
struct UserFetcher {
    
    static func main() async throws {
        let serverProjectZip = Bundle.module.url(forResource: "Server", withExtension: ".zip")!
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempUIUnitTestDirectory = tempDirectory.appendingPathComponent("UIUnitTest/")
        let tempFile = tempUIUnitTestDirectory.appending(path: "Server.zip", directoryHint: .notDirectory)
        let tempFileUrl = URL(string: "file://\(serverProjectZip)")!
        
        print(tempFile)
        try? FileManager.default.removeItem(at: tempFile)
        try FileManager.default.createDirectory(at: tempUIUnitTestDirectory, withIntermediateDirectories: true)
        
        print(tempFile.path)
        try FileManager.default.copyItem(at: tempFileUrl, to: tempFile)
        
        await executeShellCommand("unzip -o \(tempFile.path) -d \(tempUIUnitTestDirectory.path)")
        
        let rootFolder = String(tempFile.pathComponents.dropLast().joined(separator: "/").dropFirst())
        
//        let device = await openDevices().first!
        await boot()
        
        
//        await executeShellCommand("xcodebuild -project \(rootFolder)/Server/Server.xcodeproj -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=\(device.name)' test")
        
        while true {
            await executeShellCommand("xcodebuild -project \(rootFolder)/Server/Server.xcodeproj -scheme ServerUITests -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' test")
        }
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
func executeShellCommand(_ command: String) async -> Data {
    
    print("Executing command: \(command)")
    
    let task = Process()
    let pipe = Pipe()
        
    task.standardOutput = pipe
    task.standardError = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil
    task.arguments = ["-c", command]
    task.launch()
    

    var data = Data()
    
    do {
        for try await line in pipe.fileHandleForReading.bytes {
            data.append(Data(bytes: [line], count: 1))
            
            if let string = String(bytes: [line], encoding: .utf8) {
                print(string, terminator: "")
            }
            
        }
    } catch {
        
    }
    
    return data
}

@available(macOS 12.0, *)
func executeShellCommand2(_ command: String) async -> String {
    let data: Data = await executeShellCommand(command)
    let output = String(data: data, encoding: .utf8)!
    return output
}

