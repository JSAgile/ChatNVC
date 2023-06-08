//
//  SwiftUIView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI
import Speech

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                NavigationLink(destination: ApiKeyView()) {
                    Text("API Key")
                }
                NavigationLink(destination: RephraseView()) {
                    Text("Rephrase")
                }
                NavigationLink(destination: BubblePopView()) {
                    Text("Bubbles")
                }
            }
        }
    }
}
