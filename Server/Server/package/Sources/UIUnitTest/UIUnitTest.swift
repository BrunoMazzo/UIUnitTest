import Foundation

public class UI {
    private var matchers: [ElementMatcher] = []

    public init() {
        
    }
    
    public func button(identifier: String) -> Self {
        self.matchers.append(.button(identifier: identifier))
        return self
    }
    
    public func staticText(label: String) -> Self {
        self.matchers.append(.staticText(label: label))
        return self
    }

    
    public static func activate(appId: String = "bruno.mazzo.Client") async {
        let activateRequestData = ActivateRequest(appId: appId)
        
        let encoder = JSONEncoder()
        
        let activateUrl = URL(string: "http://localhost:22087/Activate")!
        var activateRequest = URLRequest(url: activateUrl)
        activateRequest.httpMethod = "POST"
        activateRequest.httpBody = try! encoder.encode(activateRequestData)
        
        _ = try! await URLSession.shared.data(for: activateRequest)
    }
    
    public func tap() async {
        let activateRequestData = TapRequest(matchers: self.matchers)
        
        let encoder = JSONEncoder()
        
        let activateUrl = URL(string: "http://localhost:22087/Tap")!
        var activateRequest = URLRequest(url: activateUrl)
        activateRequest.httpMethod = "POST"
        activateRequest.httpBody = try! encoder.encode(activateRequestData)
        
            _ = try! await URLSession.shared.data(for: activateRequest)
    }
    
    public func exists() async -> Bool {
        let activateRequestData = ExistsRequest(matchers: self.matchers)
        
        let encoder = JSONEncoder()
        
        let activateUrl = URL(string: "http://localhost:22087/exists")!
        var activateRequest = URLRequest(url: activateUrl)
        activateRequest.httpMethod = "POST"
        activateRequest.httpBody = try! encoder.encode(activateRequestData)
        
        let (data, _) = try! await URLSession.shared.data(for: activateRequest)
        
        let decoder = JSONDecoder()
        
        let existsResponse = try! decoder.decode(ExistsResponse.self, from: data)
        
        return existsResponse.exists
    }
    
}

public struct ActivateRequest: Codable {
    public var appId: String
    
    public init(appId: String) {
        self.appId = appId
    }
}

public enum ElementMatcher: Codable {
    case button(identifier: String)
    case staticText(label: String)
}

public struct TapRequest: Codable {
    
    public var matchers: [ElementMatcher]
    
    public init(matcher: ElementMatcher) {
        self.matchers = [matcher]
    }
    
    public init(matchers: [ElementMatcher]) {
        self.matchers = matchers
    }
}

public struct ExistsRequest: Codable {
    public var matchers: [ElementMatcher]
    
    public init(matchers: [ElementMatcher]) {
        self.matchers = matchers
    }
}

public struct ExistsResponse: Codable {
    public var exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}
