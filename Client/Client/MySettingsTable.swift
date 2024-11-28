import SwiftUI

struct MySettingTable: View {
    @State var navigationStack: [String] = []
    @State var isDoubleTap = false

    var body: some View {
        NavigationStack(path: $navigationStack) {
            List {
                NavigationLink("Something", destination: SomethingView())
                NavigationLink(value: "Hello world") {
                    Text("Hello world button")
                }
                NavigationLink("Stepper", destination: StepperView())
                NavigationLink("TextField", destination: TextFieldsView())
                Text("Double tap")
                    .onTapGesture(count: 2) {
                        navigationStack.append("Double tap")
                    }
            }
            .navigationDestination(for: String.self) { value in
                StringView(value: value)
            }
        }
    }
}
