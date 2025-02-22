import Foundation
import UIUnitTestAPI

public extension SyncElement {
    @available(*, noasync)
    var exists: Bool {
        Executor.execute {
            try await self.element.exists
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    func waitForExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.element.waitForExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.element.waitForNonExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    var isHittable: Bool {
        Executor.execute {
            try await self.element.isHittable
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    var value: String? {
        Executor.execute {
            try await self.element.value
        }.valueOrFailWithFallback(nil)
    }

    @available(*, noasync)
    func descendants(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.element.descendants(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.element.children(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        Executor.execute {
            try await self.element.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    func typeText(_ text: String) {
        Executor.execute {
            try await self.element.typeText(text)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    var debugDescription: String {
        Executor.execute {
            try await self.element.debugDescription
        }.valueOrFailWithFallback("")
    }

    @available(*, noasync)
    var identifier: String {
        Executor.execute {
            try await self.element.identifier
        }.valueOrFailWithFallback("")
    }

    @available(*, noasync)
    var title: String {
        Executor.execute {
            try await self.element.title
        }.valueOrFailWithFallback("")
    }

    @available(*, noasync)
    var label: String {
        Executor.execute {
            try await self.element.label
        }.valueOrFailWithFallback("")
    }

    @available(*, noasync)
    var placeholderValue: String? {
        Executor.execute {
            try await self.element.placeholderValue
        }.valueOrFailWithFallback(nil)
    }

    @available(*, noasync)
    var isSelected: Bool {
        Executor.execute {
            try await self.element.isSelected
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    var hasFocus: Bool {
        Executor.execute {
            try await self.element.hasFocus
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    var isEnabled: Bool {
        Executor.execute {
            try await self.element.isEnabled
        }.valueOrFailWithFallback(false)
    }

    @available(*, noasync)
    func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        Executor.execute {
            try await self.element.coordinate(withNormalizedOffset: normalizedOffset)
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }

    @available(*, noasync)
    var frame: CGRect {
        Executor.execute {
            try await self.element.frame
        }.valueOrFailWithFallback(.null)
    }

    @available(*, noasync)
    var horizontalSizeClass: SizeClass {
        Executor.execute {
            try await self.element.horizontalSizeClass
        }.valueOrFailWithFallback(.unspecified)
    }

    @available(*, noasync)
    var verticalSizeClass: SizeClass {
        Executor.execute {
            try await self.element.verticalSizeClass
        }.valueOrFailWithFallback(.unspecified)
    }

    @available(*, noasync)
    var elementType: Element.ElementType {
        Executor.execute {
            try await self.element.elementType
        }.valueOrFailWithFallback(.any)
    }
}
