import Foundation
import UIUnitTestAPI

extension SyncElement {

    @available(*, noasync)
    public var exists: Bool {
        Executor.execute {
            try await self.element.exists()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.element.waitForExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func waitForNonExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.element.waitForNonExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isHittable: Bool {
        Executor.execute {
            try await self.element.isHittable
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var value: String? {
        Executor.execute {
            try await self.element.value
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public func descendants(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.element.descendants(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.element.children(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        Executor.execute {
            try await self.element.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func typeText(_ text: String) {
        Executor.execute {
            try await self.element.typeText(text)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.element.debugDescription
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var identifier: String {
        Executor.execute {
            try await self.element.identifier
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var title: String {
        Executor.execute {
            try await self.element.title
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var label: String {
        Executor.execute {
            try await self.element.label
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var placeholderValue: String? {
        Executor.execute {
            try await self.element.placeholderValue
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public var isSelected: Bool {
        Executor.execute {
            try await self.element.isSelected
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var hasFocus: Bool {
        Executor.execute {
            try await self.element.hasFocus
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isEnabled: Bool {
        Executor.execute {
            try await self.element.isEnabled
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        Executor.execute {
            try await self.element.coordinate(withNormalizedOffset: normalizedOffset)
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }
    
    @available(*, noasync)
    public var frame: CGRect {
        Executor.execute {
            try await self.element.frame
        }.valueOrFailWithFallback(.null)
    }
    
    @available(*, noasync)
    public var horizontalSizeClass: SizeClass {
        Executor.execute {
            try await self.element.horizontalSizeClass
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var verticalSizeClass: SizeClass {
        Executor.execute {
            try await self.element.verticalSizeClass
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var elementType: Element.ElementType {
        Executor.execute {
            try await self.element.elementType
        }.valueOrFailWithFallback(.any)
    }
}
