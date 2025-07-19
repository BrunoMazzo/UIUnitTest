import SwiftUI

struct ContentView: View {
    // Grouped test views for better organization
    let testViewGroups: [(groupName: String, views: [(name: String, view: AnyView)])] = [
        ("Interaction Tests", [
            ("Tap", AnyView(TapView())),
            ("Press and Hold", AnyView(PressAndHoldView())),
            ("Swipe", AnyView(SwipeView())),
            ("Pinch", AnyView(PinchView())),
            ("Rotate", AnyView(RotateView()))
        ]),
        ("Input Tests", [
            ("Text Field", AnyView(TextFieldsView())),
            ("Stepper", AnyView(StepperView())),
            ("String", AnyView(StringView(value: "Some String")))
        ]),
        ("Advanced Tests", [
            ("Accessibility Audit", AnyView(AccessibilityAuditView())),
            ("Go To Background", AnyView(GoToBackgroundAndBackView())),
            ("Wait for Existence", AnyView(WaitForExistenceView())),
            ("Something", AnyView(SomethingView()))
        ])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(testViewGroups.indices, id: \.self) { groupIndex in
                    Section(header: 
                        Text(testViewGroups[groupIndex].groupName)
                            .font(.headline)
                            .foregroundColor(.primary)
                    ) {
                        ForEach(testViewGroups[groupIndex].views, id: \.name) { testView in
                            NavigationLink(destination: testView.view) {
                                Text(testView.name)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("UI Unit Test Screens")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
