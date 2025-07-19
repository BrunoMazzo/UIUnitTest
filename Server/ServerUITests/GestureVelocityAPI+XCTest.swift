import UIUnitTestAPI
import XCTest

public extension GestureVelocityAPI {
    var xcUIGestureVelocity: XCUIGestureVelocity {
        switch self {
        case .slow:
            return .slow
        case .fast:
            return .fast
        case .default:
            return .default
        case let .custom(value):
            return XCUIGestureVelocity(rawValue: value)
        }
    }
}
