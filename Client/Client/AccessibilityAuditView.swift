import SwiftUI

struct AccessibilityAuditView: View {
    var body: some View {
        VStack {
            Button("Show Message") {
                print("Test")
            }

            Text("Text label")
                .frame(width: 10, height: 10, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Show details for user")
                }
                .accessibilityHidden(true)
        }
    }
}
