import SwiftUI
#if canImport(Testing)
    import Testing
#endif
import UIKit
import XCTest

@MainActor
private func showViewFromMainActor(_ view: some View) {
    let window = getKeyWindow()
    let hostingViewController = UIHostingController(rootView: view)
    window.rootViewController = hostingViewController
}

@UIUnitTestActor
public func showView<T: View>(_ view: T) {
    let box = SendableBox(value: view)
    _ = syncFromMainActor {
        showViewFromMainActor(box.value!)
        return true
    }
}

@MainActor
private func showViewFromMainActor(_ viewController: UIViewController) {
    let window = getKeyWindow()
    window.rootViewController = viewController
}

@UIUnitTestActor
public func showView(_ view: UIViewController) {
    let box = SendableBox(value: view)
    _ = syncFromMainActor {
        showViewFromMainActor(box.value!)
        return true
    }
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

func fail(
    _ message: String,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    #if canImport(Testing)
        let sourceLocation = SourceLocation(fileID: "\(fileID)", filePath: "\(filePath)", line: Int(line), column: Int(column))
        Issue.record(Comment(stringLiteral: message), sourceLocation: sourceLocation)
    #endif
    XCTFail(message, file: filePath, line: line)
}
