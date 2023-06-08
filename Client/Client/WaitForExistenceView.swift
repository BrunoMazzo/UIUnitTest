//
//  WaitForExistenceView.swift
//  Client
//
//  Created by Bruno Mazzo on 12/3/2023.
//

import Foundation
import SwiftUI

struct WaitForExistenceView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Button("Show Message") {
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    isPresented = true
                }
            }
            if isPresented {
                Text("Hello world!")
            }
        }
    }
}
