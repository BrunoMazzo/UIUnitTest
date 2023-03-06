import XCTest
import SwiftUI
import UIKit

public extension XCTest {
    
    @MainActor
    func showView(_ view: some View) {
        let window = getKeyWindow()
        
        let hostingViewController = UIHostingController(rootView: view)
        window.rootViewController = hostingViewController
    }
    
    @MainActor
    private func getKeyWindow() -> UIWindow {
        return UIApplication.shared.connectedScenes.flatMap { scene -> [UIWindow] in
            guard let windowScene = scene as? UIWindowScene else {
                return []
            }
            
            return windowScene.windows.filter { window in
                window.isKeyWindow
            }
        }.first!
    }
}
