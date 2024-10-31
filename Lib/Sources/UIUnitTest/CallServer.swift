import Foundation
import Synchronization
import UIKit
import UIUnitTestAPI

final class ServerAPI: Sendable {
    let port: Int

    static let shared: Mutex<ServerAPI?> = Mutex(nil)

    static func loadIfNeeded() {
        ServerAPI.shared.withLock { server in
            if server == nil {
                server = ServerAPI()
            }
        }
    }

    init() {
        port = 22087 + deviceId()
    }

    func callServer<RequestData: Codable & Sendable, ResponseData: Codable & Sendable>(
        path: String,
        request: RequestData
    ) async throws -> ResponseData {
        let encoder = JSONEncoder()

        let activateUrl = URL(string: "http://localhost:\(port)/\(path)")!
        var activateRequest = URLRequest(url: activateUrl)
        activateRequest.httpMethod = "POST"
        activateRequest.httpBody = try encoder.encode(request)

        let (data, _) = try await URLSession.shared.data(for: activateRequest)

        let decoder = JSONDecoder()

        let result = try decoder.decode(UIResponse<ResponseData>.self, from: data)

        switch result.response {
        case let .success(data: response):
            return response
        case let .error(error: error):
            print(error.error)
            throw NSError(domain: "Test", code: 1, userInfo: ["reason": error])
        }
    }
}

final class SendableBox<T>: @unchecked Sendable {
    public var value: T?

    init(value: T? = nil) {
        self.value = value
    }
}

func callServer<RequestData: Codable & Sendable, ResponseData: Codable & Sendable>(
    path: String,
    request: RequestData
) async throws -> ResponseData {
    return try await withUnsafeThrowingContinuation(isolation: nil) { continuation in
        ServerAPI.shared.withLock { server in
            guard let server else {
                fatalError("Server not initialised")
            }
            Task {
                do {
                    let result: ResponseData = try await server.callServer(path: path, request: request)
                    continuation.resume(returning: result)
                } catch {
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

let deviceNameMutex = Mutex<String?>(nil)

func deviceId() -> Int {
    let deviceName = syncFromMainActor {
        UIDevice.current.name
    }
    
    var deviceId = 0
    let regulerExpression = try! NSRegularExpression(pattern: "Clone (\\d*) of .*")

    if let devicesNameMatch = regulerExpression.firstMatch(in: deviceName, range: NSRange(location: 0, length: deviceName.utf16.count)) {
        if let swiftRange = Range(devicesNameMatch.range(at: 1), in: deviceName) {
            let deviceIdString = deviceName[swiftRange]
            deviceId = Int(deviceIdString) ?? 0
        }
    }
    return deviceId
}

// Ugly but let's try to remove @MainActor requirement from many of our functions
func syncFromMainActor<T: Sendable>(body: @MainActor @escaping () -> T) -> T {
    let deviceNameMutex = Mutex<T?>(nil)
    
    Task { @MainActor in
        deviceNameMutex.withLock {
            $0 = body()
        }
    }
    
    var deviceName: T!
    while deviceName == nil {
        deviceNameMutex.withLock({ value in
            deviceName = value
        })
    }
    
    return deviceName
}
