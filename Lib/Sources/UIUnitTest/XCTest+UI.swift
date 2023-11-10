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
    let windowScene = UIApplication.shared.connectedScenes.flatMap { scene -> [UIWindowScene] in
        guard let windowScene = scene as? UIWindowScene else {
            return []
        }
        
        return [windowScene]
    }.filter { scene in
        return scene.windows.contains { window in
            window.isKeyWindow
        }
    }.first!
    
    let window = windowScene.windows.first { windows in
        windows.isKeyWindow
    }!
    
    if window is TestWindow {
        return window
    }
    
    let newTestWindow = TestWindow(windowScene: windowScene)
    newTestWindow.makeKeyAndVisible()
    return newTestWindow
}


class TestWindow: UIWindow {
    override func draw(_ rect: CGRect) {
        // Do nothing to be faster
    }
}
