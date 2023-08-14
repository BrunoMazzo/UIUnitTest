import SwiftUI

enum SwipeDirection {
    case left
    case right
    case up
    case down
    
    var description: String {
        switch self {
        case .left:
            return "Left"
        case .right:
            return "Right"
        case .up:
            return "Up"
        case .down:
            return "Down"
        }
    }
}

struct SwipeView: View {
    
    @State var direction: SwipeDirection?
    
    var body: some View {
        VStack {
            Text("Direction: \(direction?.description ?? "No swipe detected")")
            Text("Swipe me")
                .frame(width: 200, height: 200)
                .background(.green)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            direction = .left
                        }
                        if value.translation.width > 0 {
                            direction = .right
                        }
                        if value.translation.height < 0 {
                            direction = .up
                        }
                        if value.translation.height > 0 {
                            direction = .down
                        }
                    }))
        }
    }
}
