import Foundation
import UIUnitTestAPI

extension Element {
    
    @available(*, noasync)
    public var exists: Bool {
        Executor.execute {
            try await self.exists()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.waitForExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func waitForNonExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.waitForNonExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isHittable: Bool {
        Executor.execute {
            try await self.isHittable()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var value: String? {
        Executor.execute {
            try await self.value()
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public func descendants(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.descendants(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.children(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        Executor.execute {
            try await self.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func typeText(_ text: String) {
        Executor.execute {
            try await self.typeText(text)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.debugDescription()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var identifier: String {
        Executor.execute {
            try await self.identifier()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var title: String {
        Executor.execute {
            try await self.title()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var label: String {
        Executor.execute {
            try await self.label()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var placeholderValue: String? {
        Executor.execute {
            try await self.placeholderValue()
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public var isSelected: Bool {
        Executor.execute {
            try await self.isSelected()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var hasFocus: Bool {
        Executor.execute {
            try await self.hasFocus()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isEnabled: Bool {
        Executor.execute {
            try await self.isEnabled()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        Executor.execute {
            try await self.coordinate(withNormalizedOffset: normalizedOffset)
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }
    
    @available(*, noasync)
    public var frame: CGRect {
        Executor.execute {
            try await self.frame()
        }.valueOrFailWithFallback(.null)
    }
    
    @available(*, noasync)
    public var horizontalSizeClass: SizeClass {
        Executor.execute {
            try await self.horizontalSizeClass()
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var verticalSizeClass: SizeClass {
        Executor.execute {
            try await self.verticalSizeClass()
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var elementType: Element.ElementType {
        Executor.execute {
            try await self.elementType()
        }.valueOrFailWithFallback(.any)
    }
}
