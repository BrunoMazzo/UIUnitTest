import Foundation
import UIUnitTestAPI

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


