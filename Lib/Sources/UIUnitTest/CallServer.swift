import Foundation
import UIKit
import Synchronization
import UIUnitTestAPI

final class ServerAPI: Sendable {
    
    let port: Int
    
    static let shared: Mutex<ServerAPI?> = Mutex(nil)
    
    @MainActor
    static func loadIfNeeded() {
        ServerAPI.shared.withLock { server in
            if server == nil {
                server = ServerAPI()
            }
        }
    }
    
    @MainActor
    init() {
        self.port = 22087 + deviceId()
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
        case .success(data: let response):
            return response
        case .error(error: let error):
            print(error.error)
            throw NSError(domain: "Test", code: 1, userInfo: ["reason": error])
        }
    }
    
//    @available(*, noasync)
//    func callServer<RequestData: Codable & Sendable, ResponseData: Codable & Sendable>(
//        path: String,
//        request: RequestData
//    ) throws -> ResponseData {
//        let encoder = JSONEncoder()
//        
//        let activateUrl = URL(string: "http://localhost:\(port)/\(path)")!
//        var activateRequest = URLRequest(url: activateUrl)
//        activateRequest.httpMethod = "POST"
//        activateRequest.httpBody = try encoder.encode(request)
//        
//        let semaphore = DispatchSemaphore(value: 0)
//        
//        let result: SendableBox<UIResponse<ResponseData>> = SendableBox(value: nil)
//        let dataTask = URLSession.shared.dataTask(with: activateRequest) { data,_,error in
//            if let error {
//                result.value = UIResponse<ResponseData>(error: error.localizedDescription)
//            } else {
//                do {
//                    let decoder = JSONDecoder()
//                    result.value = try decoder.decode(UIResponse<ResponseData>.self, from: data!)
//                } catch {
//                    result.value = UIResponse<ResponseData>(error: error.localizedDescription)
//                }
//            }
//            semaphore.signal()
//        }
//        
//        dataTask.resume()
//        semaphore.wait()
//        
//        switch result.value!.response {
//        case .success(data: let response):
//            return response
//        case .error(error: let error):
//            print(error.error)
//            throw NSError(domain: "Test", code: 1, userInfo: ["reason": error])
//        }
//    }
}

final class SendableBox<T: Sendable>: @unchecked Sendable {
    public var value: T?
    
    init(value: T? = nil) {
        self.value = value
    }
}

func callServer<RequestData: Codable & Sendable, ResponseData: Codable & Sendable>(
    path: String,
    request: RequestData
) async throws -> ResponseData {
    return try await withUnsafeThrowingContinuation(isolation: nil, { continuation in
        ServerAPI.shared.withLock({ server in
            guard let server else {
                fatalError("Server not initialised")
            }
            Task {
                do {
                    let result: ResponseData = try await server.callServer(path: path, request: request)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        })
    })
}

//func callServer<RequestData: Codable & Sendable, ResponseData: Codable & Sendable>(
//    path: String,
//    request: RequestData
//) -> ResponseData {
//    try! ServerAPI.shared.callServer(path: path, request: request)
//}

@MainActor
func deviceId() -> Int {
    let deviceName = UIDevice.current.name
    
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




