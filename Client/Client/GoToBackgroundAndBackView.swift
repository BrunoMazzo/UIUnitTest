//
//  GoToBackgroundAndBackView.swift
//  Client
//
//  Created by Bruno Mazzo on 12/3/2023.
//

import Foundation
import SwiftUI


// TODO: Investigate why ScenePhase is not working
struct GoToBackgroundAndBackView: View {
    @State private var wasInBackground = false
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            Text("WasInBackground: \(String(wasInBackground))")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            wasInBackground = true
        }.onChange(of: scenePhase) { newValue in
            print(newValue)
        }
    }
}
