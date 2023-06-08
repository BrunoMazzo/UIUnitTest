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
    
    @State var navigationStack: [String] = []
    @State var isDoubleTap = false
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack(path: $navigationStack) {
                List {
                    NavigationLink("Something", destination: SomethingView())
                    NavigationLink(value: "Hello world") {
                        Text("Hello world button")
                    }
                    NavigationLink("Stepper", destination: StepperView())
                    NavigationLink("TextField", destination: TextFieldsView())
                    Text("Double tap")
                        .onTapGesture(count: 2) {
                            navigationStack.append("Double tap")
                        }
                }
                .navigationDestination(for: String.self) { value in
                    StringView(value: value)
                }
            }
        } else {
            NavigationView {
                List {
                    NavigationLink("Something", destination: SomethingView())
                    NavigationLink {
                        StringView(value: "Hello world")
                    } label: {
                        Text("Hello world button")
                    }
                    NavigationLink("Stepper", destination: StepperView())
                    NavigationLink("TextField", destination: TextFieldsView())
                    Text("Double tap")
                        .onTapGesture(count: 2) {
                            isDoubleTap = true
                        }
                    NavigationLink("Double tap w", destination: StringView(value: "Double tap"), isActive: $isDoubleTap)
                }
            }
        }
    }
}

struct TextFieldsView: View {
    
    @State var textFieldValue: String = ""
    
    var body: some View {
        VStack {
            Text("Text value: \(textFieldValue)")
            if #available(iOS 16.0, *) {
                LabeledContent("Default") {
                    TextField("Default", text: $textFieldValue)
                        .accessibilityIdentifier("TextField-Default")
                }
            } else {
                // Fallback on earlier versions
                VStack(alignment: .leading) {
                    Text("Default")
                    TextField("Default", text: $textFieldValue)
                        .accessibilityIdentifier("TextField-Default")
                }
            }
        }
    }
}

struct StepperView: View {
    @State var value: Int = 0
    
    var body: some View {
        Stepper("Stepper", value: $value)
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
                .accessibilityIdentifier("Something View")
                .accessibilityLabel("SomethingViewAccessbilityLabel")
        }
    }
}
