import Foundation

public class App: Element {
    let appId: String
    let executor = Executor()
    
    public init(appId: String, activate: Bool = true) async throws {
        self.appId = appId
        super.init(serverId: UUID())
        
        try await self.create(activate: activate)
    }
    
    @available(*, noasync)
    public init(appId: String, activate: Bool = true) {
        self.appId = appId
        super.init(serverId: UUID())
        self.create(activate: activate)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public func pressHomeButton() async throws {
        let _: Bool = try await callServer(path: "HomeButton", request: HomeButtonRequest())
    }
    
    @available(*, noasync)
    public func pressHomeButton() {
        Executor.execute {
            try await self.pressHomeButton()
        }
    }
    
    public func activate() async throws {
        let activateRequestData = ActivateRequest(serverId: self.serverId)
        
        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
    }
    
    @available(*, noasync)
    public func activate() {
        Executor.execute {
            try await self.activate()
        }
    }
    
    private func create(activate: Bool) async throws {
        var retries = 3
        while retries > 0 {
            do {
                let request = CreateApplicationRequest(appId: self.appId, serverId: self.serverId, activate: activate)
                
                let _: Bool = try await callServer(path: "createApp", request: request)
                return
            } catch {
                retries -= 1
                try await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
    
    @available(*, noasync)
    public func create(activate: Bool) {
        Executor.execute {
            try await self.create(activate: activate)
        }
    }
}

public struct CreateApplicationRequest: Codable {
    
    public let serverId: UUID
    public let appId: String
    public let activate: Bool
    
    public init(appId: String, serverId: UUID, activate: Bool) {
        self.appId = appId
        self.serverId = serverId
        self.activate = activate
    }
}

public struct ActivateRequest: Codable {
    
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}


public struct HomeButtonRequest: Codable {
    
}

public struct EnterTextRequest: Codable {
    
    public var serverId: UUID
    public var textToEnter: String
    
    public init(serverId: UUID, textToEnter: String) {
        self.serverId = serverId
        self.textToEnter = textToEnter
    }
}
