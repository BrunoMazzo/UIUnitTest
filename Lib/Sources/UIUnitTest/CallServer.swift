import Foundation
import UIKit

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

internal func callServer<RequestData: Codable, ResponseData: Codable>(
    path: String,
    request: RequestData
) async throws -> ResponseData {
    let encoder = JSONEncoder()
    
    let port = 22087 + deviceId()
    
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

public enum Response<T: Codable> {
    case error(error: ErrorResponse)
    case success(data: T)
}

public struct ErrorResponse: Codable {
    var error: String
}

public struct UIResponse<T: Codable>: Codable {
    
    public let response: Response<T>
    
    public init(response: T) {
        self.response = .success(data: response)
    }
    
    public init(error: String) {
        self.response = .error(error: ErrorResponse(error: error))
    }
    
    enum CodingKeys: CodingKey {
        case data
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let error = try container.decodeIfPresent(ErrorResponse.self, forKey: .error) {
            self.response = .error(error: error)
        } else if let response = try container.decodeIfPresent(T.self, forKey: .data) {
            self.response = .success(data: response)
        } else {
            fatalError("Invalid response")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self.response {
        case .error(error: let error):
            try container.encode(error, forKey: .error)
        case .success(data: let data):
            try container.encode(data, forKey: .data)
        }
    }
    
}
