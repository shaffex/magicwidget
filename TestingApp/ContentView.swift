//
//  ContentView.swift
//  TestingApp
//
//  Created by Peter Popovec on 29/03/2026.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Reload") {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
