import Foundation
import SwiftUI

// Schene phase only works when using SwiftIU App
struct GoToBackgroundAndBackView: View {
    @State private var wasInBackground = false

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            Text("WasInBackground: \(String(wasInBackground))")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            wasInBackground = true
        }.onChange(of: scenePhase) { newValue in
            print(newValue)
        }
    }
}
