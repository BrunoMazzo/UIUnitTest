import SwiftUI

struct StringView: View {
    var value: String

    var body: some View {
        VStack {
            Text("Value: \(value)")
        }
    }
}
