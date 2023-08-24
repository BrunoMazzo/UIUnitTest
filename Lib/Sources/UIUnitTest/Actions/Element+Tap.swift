import Foundation

extension Element {
    public func tap() async throws {
        let tapElementResponse = TapElementRequest(serverId: self.serverId)
        
        let _: Bool = try await callServer(path: "tapElement", request: tapElementResponse)
    }
    
    public func twoFingerTap() async throws {
        let activateRequestData = TapElementRequest(serverId: self.serverId, numberOfTouches: 2)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
    
    public func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) async throws {
        let activateRequestData = TapElementRequest(serverId: self.serverId, numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
    
    public func press(forDuration duration: TimeInterval) async throws {
        let activateRequestData = TapElementRequest(serverId: self.serverId, duration: duration)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
}

extension SyncElement {
    public func tap() {
        self.executor.execute {
            try await self.element.tap()
        }
    }
    
    public func twoFingerTap() {
        self.executor.execute {
            try await self.element.twoFingerTap()
        }
    }
    
    public func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) {
        self.executor.execute {
            try await self.element.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        }
    }
    
    public func press(forDuration duration: TimeInterval) {
        self.executor.execute {
            try await self.element.press(forDuration: duration)
        }
    }
}

public struct TapElementRequest: Codable {
    
    public var serverId: UUID
    public var duration: TimeInterval?
    public var numberOfTaps: Int?
    public var numberOfTouches: Int?
    
    init(serverId: UUID, duration: TimeInterval? = nil, numberOfTaps: Int? = nil, numberOfTouches: Int? = nil) {
        self.serverId = serverId
        self.duration = duration
        self.numberOfTaps = numberOfTaps
        self.numberOfTouches = numberOfTouches
    }
}
