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

    @available(*, noasync)
    public func tap() {
        Executor.execute {
            try await self.tap()
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func twoFingerTap() {
        Executor.execute {
            try await self.twoFingerTap()
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) {
        Executor.execute {
            try await self.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func press(forDuration duration: TimeInterval) {
        Executor.execute {
            try await self.press(forDuration: duration)
        }.valueOrFailWithFallback(())
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
