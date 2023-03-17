//
//  PinchView.swift
//  Client
//
//  Created by Bruno Mazzo on 18/3/2023.
//

import Foundation
import SwiftUI

struct PinchView: View {
    
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    var body: some View {
        VStack {
            Text("Current Scale: \(finalAmount + currentAmount)")
            Text("Did scale? \(finalAmount + currentAmount > 2 ? "Yes" : "No")")
            Spacer()
            Text("Pinch me")
                .frame(width: 100, height: 100)
                .background(.green)
                .scaleEffect(finalAmount + currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged { amount in
                            currentAmount = amount - 1
                        }
                        .onEnded { amount in
                            finalAmount += currentAmount
                            currentAmount = 0
                        }
                )
                .accessibilityIdentifier("PinchContainer")
            Spacer(minLength: 40)
        }
    }
}
