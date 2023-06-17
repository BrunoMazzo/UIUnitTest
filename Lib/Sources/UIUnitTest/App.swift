import Foundation

public class App: ElementTypeQueryProvider {
    public var queryServerId: UUID? = nil
    
    let appId: String
    
    public init(appId: String) async throws {
        self.appId = appId
        try await self.activate()
    }
    
    public func pressHomeButton() async throws {
        let _: Bool = try await callServer(path: "HomeButton", request: HomeButtonRequest())
    }
    
    public func activate() async throws {
        let activateRequestData = ActivateRequest(appId: appId)
        
        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
    }
}

public enum Response {
    case error(error: ErrorResponse)
    case success(data: Codable)
}

public struct ErrorResponse: Codable {
    var error: String
}

public struct UIResponse<T: Codable>: Codable {
    
    public let response: Response
    
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

internal func callServer<RequestData: Codable, ResponseData: Codable>(path: String, request: RequestData) async throws -> ResponseData {
    let encoder = JSONEncoder()
    
    let activateUrl = URL(string: "http://localhost:22087/\(path)")!
    var activateRequest = URLRequest(url: activateUrl)
    activateRequest.httpMethod = "POST"
    activateRequest.httpBody = try encoder.encode(request)
    
    let (data, _) = try await URLSession.shared.data(for: activateRequest)
    
    let decoder = JSONDecoder()
    
    let result = try decoder.decode(UIResponse<ResponseData>.self, from: data)
    
    switch result.response {
    case .success(data: let response):
        return response as! ResponseData
    case .error(error: let error):
        
        print(error.error)
        
        throw NSError(domain: "Test", code: 1, userInfo: ["reason": error])
    }
}

public struct ActivateRequest: Codable {
    public var appId: String
    
    public init(appId: String) {
        self.appId = appId
    }
}


public struct HomeButtonRequest: Codable {
    
}

public struct EnterTextRequest: Codable {
    
    public var elementServerId: UUID
    public var textToEnter: String
    
    public init(elementServerId: UUID, textToEnter: String) {
        self.elementServerId = elementServerId
        self.textToEnter = textToEnter
    }
}
