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
                    try? await Task.sleep(for: .seconds(1))
                    isPresented = true
                }
            }
            if isPresented {
                Text("Hello world!")
            }
        }
    }
}
