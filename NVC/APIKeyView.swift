//
//  APIKeyView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI

struct ApiKeyView: View {
    @State private var apiKey: String = ""

    var body: some View {
        VStack {
            TextField("Enter OpenAI API Key", text: $apiKey)
                .padding()
                .background(Color.white)
                .border(Color.gray, width: 0.5)
            Button(action: {
                saveAPIKey()
            }) {
                Text("Save API Key")
                .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: Double(42) / 255, green: Double(157) / 255, blue: Double(143) / 255))
        .ignoresSafeArea()
        .navigationBarTitle("API Key", displayMode: .inline)
    }

    func saveAPIKey() {
        // save apiKey to UserDefault or Keychain
        UserDefaults.standard.set(apiKey, forKey: "OpenAI_API_KEY")
    }
}

struct APIKeyView_Previews: PreviewProvider {
    static var previews: some View {
        ApiKeyView()
    }
}
