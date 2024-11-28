import SwiftUI

struct StepperView: View {
    @State var value: Int = 0

    var body: some View {
        Stepper("Stepper", value: $value)
    }
}
