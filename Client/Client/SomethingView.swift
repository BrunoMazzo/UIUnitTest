import SwiftUI

struct SomethingView: View {
    var body: some View {
        VStack {
            Text("Something View")
                .accessibilityIdentifier("Something View")
                .accessibilityLabel("SomethingViewAccessbilityLabel")
        }
    }
}
