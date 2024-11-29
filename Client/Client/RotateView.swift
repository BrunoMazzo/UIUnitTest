import Foundation
import SwiftUI

struct RotateView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero

    var body: some View {
        VStack {
            Text("Current rotation: \(finalAmount.degrees + currentAmount.degrees)")
            Text("Did rotate? \(finalAmount.radians + currentAmount.radians > 1 ? "Yes" : "No")")
            Spacer()
            Text("Rotate me!")
                .frame(width: 200, height: 200)
                .background(.green)
                .rotationEffect(currentAmount + finalAmount)
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            currentAmount = angle
                        }
                        .onEnded { _ in
                            finalAmount += currentAmount
                            currentAmount = .zero
                        }
                )
            Spacer()
        }
    }
}
