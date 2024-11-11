import SwiftUI

struct TextFieldsView: View {
    @State var textFieldValue: String = ""

    var body: some View {
        VStack {
            Text("Text value: \(textFieldValue)")
            LabeledContent("Default") {
                TextField("Default", text: $textFieldValue)
                    .accessibilityIdentifier("TextField-Default")
            }
        }
    }
}
