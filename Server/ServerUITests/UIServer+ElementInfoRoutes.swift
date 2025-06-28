import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Element Info Routes
extension UIServer {
    /// Registers routes for element information retrieval
    /// - identifier: Gets element identifier
    /// - title: Gets element title
    /// - label: Gets element label
    /// - placeholderValue: Gets element placeholder value
    /// - isSelected: Checks if element is selected
    /// - hasFocus: Checks if element has focus
    /// - isEnabled: Checks if element is enabled
    /// - elementType: Gets element type
    /// - frame: Gets element frame
    /// - horizontalSizeClass: Gets horizontal size class
    /// - verticalSizeClass: Gets vertical size class
    func registerElementInfoRoutes() async {
        await addRoute("identifier", handler: identifier(request:))
        await addRoute("title", handler: title(request:))
        await addRoute("label", handler: label(request:))
        await addRoute("placeholderValue", handler: placeholderValue(request:))
        await addRoute("isSelected", handler: isSelected(request:))
        await addRoute("hasFocus", handler: hasFocus(request:))
        await addRoute("isEnabled", handler: isEnabled(request:))
        await addRoute("elementType", handler: elementType(request:))
        await addRoute("frame", handler: frame(request:))
        await addRoute("horizontalSizeClass", handler: horizontalSizeClass(request:))
        await addRoute("verticalSizeClass", handler: verticalSizeClass(request:))
    }
}
