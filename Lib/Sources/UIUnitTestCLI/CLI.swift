import Foundation

@available(iOS 16.0, *)
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
    }
}

@discardableResult
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
        print("Error: --------------------------------------")
        print(error.localizedDescription)
        print("Error: --------------------------------------")
    }
    
    return data
}

@_disfavoredOverload
func executeShellCommand(_ command: String) async -> String {
    let data: Data = await executeShellCommand(command)
    let output = String(data: data, encoding: .utf8)!
    return output
}
