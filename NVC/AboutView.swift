//
//  AboutView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("About This App")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Text("This app was created by Jesse Shepard & ChatGPT.")
                    .foregroundColor(.white)
                    .padding()

                Text("Contact: ChatNVC@fastmail.com")
                    .foregroundColor(.white)
                    .padding()

                Text("What is NVC?")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                Text("Nonviolent Communication (NVC) is a method of communication and a" +
                    " mindset that enables us to empathize with others and honestly express ourselves." +
                    " It helps to create a positive connection and resolve conflicts amicably.")
                    .foregroundColor(.white)
                    .padding()

                Text("The NVC Steps")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                Text("""
                    1. Observation: State the facts we observe that are affecting our well-being.
                    2. Feelings: Share how we feel in relation to what we observe.
                    3. Needs: State what we need or value that causes our feelings.
                    4. Request: The concrete actions we request to enrich our lives.
                    """)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: Double(42) / 255, green: Double(157) / 255, blue: Double(143) / 255))
            .ignoresSafeArea()
        }
        .navigationBarTitle("About", displayMode: .inline)
        .foregroundColor(.white)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
