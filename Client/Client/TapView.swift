import Foundation
import SwiftUI

struct TapView: View {
    @State var twoFingersTap = false
    @State var threeFingersTap = false

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header section
                VStack(spacing: 12) {
                    Text("Multi-Touch Gesture Demo")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Test different multi-touch gestures by tapping the areas below with the specified number of fingers")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                .padding(.top, 10)
                
                // Two finger tap section
                VStack(spacing: 20) {
                    Text("Two Finger Tap")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TappableView(
                        numberOfTouches: 2,
                        accessibilityIdentifier: "TwoFingersView",
                        title: "Tap with 2 fingers",
                        subtitle: "Touch this area with two fingers simultaneously",
                        backgroundColor: .blue
                    ) { _ in
                        print("Two fingers tapped")
                        withAnimation(.easeInOut(duration: 0.3)) {
                            twoFingersTap = true
                        }
                    }
                    .frame(height: 120)
                    .padding(.horizontal, 4)
                    
                    if twoFingersTap {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Two fingers tapped successfully!")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                
                // Three finger tap section
                VStack(spacing: 20) {
                    Text("Three Finger Tap")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TappableView(
                        numberOfTouches: 3,
                        accessibilityIdentifier: "ThreeFingersView",
                        title: "Tap with 3 fingers",
                        subtitle: "Touch this area with three fingers simultaneously",
                        backgroundColor: .purple
                    ) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            threeFingersTap = true
                        }
                    }
                    .frame(height: 120)
                    .padding(.horizontal, 4)
                    
                    if threeFingersTap {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Three fingers tapped successfully!")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                
                // Reset button section
                if twoFingersTap || threeFingersTap {
                    VStack(spacing: 16) {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                twoFingersTap = false
                                threeFingersTap = false
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                Text("Reset All")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.gray)
                            .cornerRadius(8)
                        }
                        .accessibilityIdentifier("ResetButton")
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .navigationTitle("Multi-Touch Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TappableView: UIViewRepresentable {
    var numberOfTouches: Int = 2
    var accessibilityIdentifier: String
    var title: String = ""
    var subtitle: String = ""
    var backgroundColor: Color = .blue
    var tapCallback: (UITapGestureRecognizer) -> Void

    typealias UIViewType = UIView

    func makeCoordinator() -> TappableView.Coordinator {
        Coordinator(tapCallback: tapCallback)
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(backgroundColor)
        containerView.accessibilityIdentifier = accessibilityIdentifier
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        
        // Accessibility configuration
        containerView.isAccessibilityElement = true
        containerView.accessibilityLabel = title.isEmpty ? "Tappable area" : title
        containerView.accessibilityHint = subtitle.isEmpty ? "Tap with \(numberOfTouches) fingers" : subtitle
        containerView.accessibilityTraits = .button
        
        // Create content stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        
        // Add title label
        if !title.isEmpty {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.isAccessibilityElement = false
            stackView.addArrangedSubview(titleLabel)
        }
        
        // Add subtitle label
        if !subtitle.isEmpty {
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            subtitleLabel.isAccessibilityElement = false
            stackView.addArrangedSubview(subtitleLabel)
        }
        
        // Add finger count indicator
        let fingerCountLabel = UILabel()
        fingerCountLabel.text = String(repeating: "👆", count: numberOfTouches)
        fingerCountLabel.font = UIFont.systemFont(ofSize: 24)
        fingerCountLabel.textAlignment = .center
        fingerCountLabel.isAccessibilityElement = false
        fingerCountLabel.accessibilityLabel = "\(numberOfTouches) fingers required"
        stackView.addArrangedSubview(fingerCountLabel)
        
        containerView.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16)
        ])
        
        // Set up gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(sender:))
        )
        tapGestureRecognizer.numberOfTouchesRequired = numberOfTouches
        tapGestureRecognizer.delegate = context.coordinator
        containerView.addGestureRecognizer(tapGestureRecognizer)
        
        // Add visual feedback for touch
        let longPressGesture = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleLongPress(sender:))
        )
        longPressGesture.minimumPressDuration = 0.0
        longPressGesture.numberOfTouchesRequired = numberOfTouches
        longPressGesture.delegate = context.coordinator
        containerView.addGestureRecognizer(longPressGesture)
        
        // Add border for better visual definition
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = UIColor(backgroundColor)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var tapCallback: (UITapGestureRecognizer) -> Void

        init(tapCallback: @escaping (UITapGestureRecognizer) -> Void) {
            self.tapCallback = tapCallback
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }

        @objc func handleTap(sender: UITapGestureRecognizer) {
            Task { @MainActor in
                // Add haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()

                self.tapCallback(sender)
            }
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.1) {
                    sender.view?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    sender.view?.alpha = 0.8
                }
            case .ended, .cancelled:
                UIView.animate(withDuration: 0.1) {
                    sender.view?.transform = CGAffineTransform.identity
                    sender.view?.alpha = 1.0
                }
            default:
                break
            }
        }
    }
}
