import Foundation
import SwiftUI

struct WaitForExistenceView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Button("Show Message") {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    isPresented = true
                }
            }
            if isPresented {
                Text("Hello world!")
            }
        }
    }
}


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

#Preview {
    AccessibilityAuditView()
}
