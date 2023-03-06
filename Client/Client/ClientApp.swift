//
//  ClientApp.swift
//  Client
//
//  Created by Bruno Mazzo on 5/3/2023.
//

import SwiftUI

@main
struct ClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct MySettingTable: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Something", destination: SomethingView())
                NavigationLink(value: "Hello world") {
                    Text("Hello world button")
                }
            }
            .navigationDestination(for: String.self) { value in
                StringView(value: value)
            }
        }
    }
}

struct StringView: View {
    
    var value: String
    
    var body: some View {
        VStack {
            Text("Value: \(value)")
        }
    }
}

struct SomethingView: View {
    var body: some View {
        VStack {
            Text("Something View")
        }
    }
}
