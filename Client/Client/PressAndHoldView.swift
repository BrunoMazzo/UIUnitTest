import Foundation
import SwiftUI

struct PressAndHoldView: View {
    @State var showMessage: Bool = false
    
    var body: some View {
        VStack {
            Text("Press and hold")
                .onLongPressGesture(minimumDuration: 2) {
                    showMessage = true
                }
            if showMessage {
                Text("Hello world!")
            }
        }
    }
}
