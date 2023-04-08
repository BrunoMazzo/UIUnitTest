import ArgumentParser
import Foundation

@available(iOS 16.0, *)
@main
struct UIUnitTestCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility for performing operations for UIUnitTest lib.",
        version: "1.0.0",
        subcommands: [SetupCommand.self, InstallCommand.self, StartServerCommand.self],
        defaultSubcommand: StartServerCommand.self)
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

@discardableResult
func executeTestUntilServerStarts(_ command: String) async {
    
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
            
            if let fullLog = String(data: data, encoding: .utf8) {
                if fullLog.contains("Server ready") {
                    return
                }
            }
        }
    } catch {
        print("Error: --------------------------------------")
        print(error.localizedDescription)
        print("Error: --------------------------------------")
    }
}

@_disfavoredOverload
func executeShellCommand(_ command: String) async -> String {
    let data: Data = await executeShellCommand(command)
    let output = String(data: data, encoding: .utf8)!
    return output
}
