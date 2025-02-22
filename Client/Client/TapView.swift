import Foundation
import SwiftUI

struct TapView: View {

    @State var twoFingersTap = false
    @State var threeFingersTap = false

    var body: some View {
        VStack {
            Text("Two fingers tap")
// TODO: Investigate why it doesn't work on iOS 15
//                .overlay(TappableView(accessibilityIdentifier: "TwoFingersView") { gesture in
//                    twoFingersTap = true
//                })

            TappableView(accessibilityIdentifier: "TwoFingersView") { _ in
                twoFingersTap = true
            }

            if twoFingersTap {
                Text("Two fingers tapped")
            }

//            Text("Three fingers tap")
//                .overlay(TappableView(numberOfTouches: 3, accessibilityIdentifier: "ThreeFingersView") { gesture in
//                    threeFingersTap = true
//                })
            TappableView(numberOfTouches: 3, accessibilityIdentifier: "ThreeFingersView") { _ in
                threeFingersTap = true
            }
            if threeFingersTap {
                Text("Three fingers tapped")
            }
        }
    }
}

struct TappableView: UIViewRepresentable {
    var numberOfTouches: Int = 2
    var accessibilityIdentifier: String
    var tapCallback: (UITapGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> TappableView.Coordinator {
        Coordinator(tapCallback: self.tapCallback)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.accessibilityIdentifier = accessibilityIdentifier
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))

        /// Set number of touches.
        doubleTapGestureRecognizer.numberOfTouchesRequired = numberOfTouches

        view.addGestureRecognizer(doubleTapGestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }

    class Coordinator {
        var tapCallback: (UITapGestureRecognizer) -> Void

        init(tapCallback: @escaping (UITapGestureRecognizer) -> Void) {
            self.tapCallback = tapCallback
        }

        @objc func handleTap(sender: UITapGestureRecognizer) {
            self.tapCallback(sender)
        }
    }
}
