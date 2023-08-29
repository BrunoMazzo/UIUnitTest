import Foundation

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

func executeBackgroundShellCommand(_ command: String) {
    print("Executing command: \(command)")
    
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil
    task.arguments = ["-c", command]
    task.launch()
}

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
    
    var lastLine = ""
    
    do {
        for try await line in pipe.fileHandleForReading.bytes {
            if let newCharacter = String(bytes: [line], encoding: .utf8) {
                print(newCharacter, terminator: "")
                if newCharacter == "\n" {
                    if lastLine.contains("Server ready") {
                        return
                    }
                    lastLine = ""
                } else {
                    lastLine.append(newCharacter)
                }
            }
        }
    } catch {
        print("Error: --------------------------------------")
        print(error.localizedDescription)
        print("Error: --------------------------------------")
    }
}

func executeShellCommand(_ command: String) async -> String {
    let data: Data = await executeShellCommand(command)
    let output = String(data: data, encoding: .utf8)!
    return output
}
