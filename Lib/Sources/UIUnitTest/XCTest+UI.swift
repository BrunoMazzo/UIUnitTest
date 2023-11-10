import SwiftUI
import UIKit

@MainActor
public func showView(_ view: some View) {
    let window = getKeyWindow()
    let hostingViewController = UIHostingController(rootView: view)
    window.rootViewController = hostingViewController
}

@MainActor
public func showView(_ viewController: UIViewController) {
    let window = getKeyWindow()
    window.rootViewController = viewController
}



@MainActor
private func getKeyWindow() -> UIWindow {
    let window = UIApplication.shared.connectedScenes.flatMap { scene -> [UIWindow] in
        guard let windowScene = scene as? UIWindowScene else {
            return []
        }
        
        return windowScene.windows.filter { window in
            window.isKeyWindow
        }
    }.first!
    
    if window is TestWindow {
        return window
    }
    
    let newTestWindow = TestWindow(frame: UIScreen.main.bounds)
    newTestWindow.makeKeyAndVisible()
    return newTestWindow
}


class TestWindow: UIWindow {
    override func draw(_ rect: CGRect) {
        // Do nothing to be faster
    }
}
