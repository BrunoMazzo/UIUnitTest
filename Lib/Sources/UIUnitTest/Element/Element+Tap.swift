import Foundation
import UIUnitTestAPI

public extension Element {
    func tap() async throws {
        let tapElementResponse = TapElementRequest(serverId: serverId)

        let _: Bool = try await callServer(path: "tapElement", request: tapElementResponse)
    }

    func twoFingerTap() async throws {
        let activateRequestData = TapElementRequest(serverId: serverId, numberOfTouches: 2)

        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }

    func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) async throws {
        let activateRequestData = TapElementRequest(serverId: serverId, numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)

        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }

    func press(forDuration duration: TimeInterval) async throws {
        let activateRequestData = TapElementRequest(serverId: serverId, duration: duration)

        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
}

public extension SyncElement {
    @available(*, noasync)
    func tap() {
        Executor.execute {
            try await self.element.tap()
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    func twoFingerTap() {
        Executor.execute {
            try await self.element.twoFingerTap()
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) {
        Executor.execute {
            try await self.element.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    func press(forDuration duration: TimeInterval) {
        Executor.execute {
            try await self.element.press(forDuration: duration)
        }.valueOrFailWithFallback(())
    }
}
