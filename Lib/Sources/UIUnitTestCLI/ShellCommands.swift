import Foundation

@discardableResult
func executeShellCommand(_ command: String, logger: Logger = Logger()) async -> Data {
    logger.log("Executing command: \(command)")

    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") // <--updated
    task.standardInput = nil
    task.arguments = ["-c", command]
    task.launch()

    var data = Data()

    do {
        for try await line in pipe.fileHandleForReading.bytes {
            data.append(Data(bytes: [line], count: 1))

//            if let string = String(bytes: [line], encoding: .utf8) {
//                print(string, terminator: "")
//            }
        }
    } catch {
        logger.log("Error: --------------------------------------")
        logger.log(error.localizedDescription)
        logger.log("Error: --------------------------------------")
    }

    return data
}

func executeBackgroundShellCommand(_ command: String, logger: Logger = Logger()) {
    logger.log("Executing command: \(command)")

    Task {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") // <--updated
        task.standardInput = nil
        task.arguments = ["-c", command]
        task.terminationHandler = { process in
            logger.log(process)
            logger.log("\ndidFinish: \(!process.isRunning)")
        }
        task.launch()
        task.waitUntilExit()
    }
}

func executeTestUntilServerStarts(_ command: String, logger: Logger = Logger()) async {
    logger.log("Executing command: \(command)")

    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") // <--updated
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
        logger.log("Error: --------------------------------------")
        logger.log(error.localizedDescription)
        logger.log("Error: --------------------------------------")
    }
}

func executeShellCommand(_ command: String) async -> String {
    let data: Data = await executeShellCommand(command)
    let output = String(data: data, encoding: .utf8)!
    return output
}
