import UIUnitTestAPI

/// A class responsible for handling tap-related interaction methods for UI elements.
///
/// This class provides functionality to perform various types of taps on UI elements,
/// including standard taps, multi-touch taps, long presses, and double taps.
@MainActor
final class TapRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new TapRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for tap interactions
    func registerRoutes() async {
        // Note: This extension appears to be incomplete and may have duplicate functionality
        // with InteractionRoutes. Consider consolidating or removing if not needed.
    }

    /// Performs a tap action on a specified UI element with various customization options.
    ///
    /// This method allows for different types of taps based on the provided `TapElementRequest`:
    /// - Standard single tap
    /// - Tap with specific number of taps and touches
    /// - Two-finger tap
    /// - Press and hold for a specified duration
    ///
    /// - Parameters:
    ///   - tapRequest: A `TapElementRequest` containing details about the tap interaction
    /// - Returns: A boolean indicating whether the tap was successfully performed
    /// - Throws: An error if the element cannot be retrieved from the cache
    private func tapElement(tapRequest: TapElementRequest) async throws -> Bool {
        // Implementation would go here - currently missing from original file
        let element = try cache.getElement(tapRequest.serverId)
        element.tap()
        return true
    }

    /// Performs a double tap on a specified UI element.
    ///
    /// - Parameters:
    ///   - tapRequest: An `ElementPayload` containing the server ID of the element to double tap
    /// - Throws: An error if the element cannot be retrieved from the cache
    private func doubleTap(tapRequest: ElementPayload) async throws {
        let element = try cache.getElement(tapRequest.serverId)
        element.doubleTap()
    }
}

// MARK: - UIServer + Tap Routes
extension UIServer {
    /// Registers routes for tap interactions
    func registerTapRoutes() async {
        let routes = TapRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
